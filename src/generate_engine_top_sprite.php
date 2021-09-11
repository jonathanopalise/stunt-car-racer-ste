<?php

function readLongword($str, $ofs)
{
    return (ord($str[$ofs]) << 24) + (ord($str[$ofs+1])<<16) + (ord($str[$ofs+2]) << 8) + ord($str[$ofs+3]);
}

function readWord($str, $ofs)
{
    return (ord($str[$ofs]) << 8) + ord($str[$ofs+1]);
}

function getDestinationOffset($sixteenPixelBlock, $line)
{
    return $line * 160 + $sixteenPixelBlock * 8;
}

function getDestinationOffsetFromSourceOffset($sixteenPixelBlocksPerLine, $sourceOffset)
{
    $sixteenPixelBlock = $sourceOffset % $sixteenPixelBlocksPerLine;
    $line = intdiv($sourceOffset, $sixteenPixelBlocksPerLine);

    return getDestinationOffset($sixteenPixelBlock, $line);
}

function getHexLongFromWord($word)
{
    $hex = dechex($word);
    while (strlen($hex) < 4) {
        $hex = '0' . $hex;
    }

    return $hex . $hex;
}

$numberOfLines = 21;
$sixteenPixelBlocksPerLine = 16;
$sixteenPixelBlockTotal = ($sixteenPixelBlocksPerLine*$numberOfLines);


if ($argc != 3) {
    echo("Usage: generate_engine_top_sprite [inputFilename] [outputFilename]\n");
    exit();
}

$inputFilename = $argv[1];
$outputFilename = $argv[2];

$data = file_get_contents($inputFilename);
if ($data === false) {
    echo('Unable to read from '.$inputFilename."\n");
    exit(1);
}

$maskWords = [];
$index = 0;
$offset = 0;
for ($index = 0; $index < $sixteenPixelBlockTotal; $index++) {
    $maskWords[] = readWord($data, $offset);
    $offset += 10;
}

$colourLongs = [];
$index = 0;
$offset = 2;
for ($index = 0; $index < $sixteenPixelBlockTotal; $index++) {
    $colourLongs[] = [
        dechex(readLongword($data, $offset)),
        dechex(readLongword($data, $offset+4))
    ];
    $offset += 10;
}

$offsetsByMaskword = [];
foreach ($maskWords as $offset => $maskWord) {
    if (!isset($offsetsByMaskWord[$maskWord])) {
        $offsetsByMaskWord[$maskWord] = [];
    }
    $offsetsByMaskWord[$maskWord][] = $offset;
}

$instructions = [];
$handledMaskWords = [];
$maskWordsOffset = 0;
for ($line = 0; $line < $numberOfLines; $line++) {
    for ($sixteenPixelBlock = 0; $sixteenPixelBlock < $sixteenPixelBlocksPerLine; $sixteenPixelBlock++) {
        $maskWord = $maskWords[$maskWordsOffset];
        if ($maskWord != 0 && $maskWord != 0xffff && !isset($handledMaskWords[$maskWord])) {
            $offsets = $offsetsByMaskWord[$maskWord];
            sort($offsets);

            $maskValue = getHexLongFromWord($maskWord);
            $instructions[] = sprintf('move.l #$%s,d1', $maskValue);
            $previousOffset = -1;   
            foreach ($offsets as $offset) {
                $instructions[] = sprintf(
                    'and.l d1,%d(a0)',
                    getDestinationOffsetFromSourceOffset($sixteenPixelBlocksPerLine, $offset)
                );
                $instructions[] = sprintf(
                    'and.l d1,%d(a0)',
                    getDestinationOffsetFromSourceOffset($sixteenPixelBlocksPerLine, $offset) + 4
                );
                $previousOffset = $offset;
            }

            $handledMaskWords[$maskWord] = true;
        }

        $maskWordsOffset++;
    }
}

$colourLongsOffset = 0;
$operationsByOffset = [];
for ($line = 0; $line < $numberOfLines; $line++) {
    for ($sixteenPixelBlock = 0; $sixteenPixelBlock < $sixteenPixelBlocksPerLine; $sixteenPixelBlock++) {
        $colourLongPair = $colourLongs[$colourLongsOffset];
        $colourLong1 = $colourLongPair[0];
        $colourLong2 = $colourLongPair[1];

        $operation = 'or';
        $maskWord = $maskWords[$colourLongsOffset];
        if ($maskWord == 0) {
            $operation = 'move';
        } elseif ($maskWord == 0xffff) {
            $operation = null;
        }

        if (!is_null($operation)) {
            $colourLong1DestOffset = getDestinationOffsetFromSourceOffset(
                $sixteenPixelBlocksPerLine,
                $colourLongsOffset
            );
            $colourLong2DestOffset = $colourLong1DestOffset + 4;

            $operationsByOffset[$colourLong1DestOffset] = [
                'operation' => $operation,
                'value' => $colourLong1,
            ];
            $operationsByOffset[$colourLong2DestOffset] = [
                'operation' => $operation,
                'value' => $colourLong2,
            ];
        }

        $colourLongsOffset++;
    }
}

$previousDestOffset = 0;
$currentSpan = [];
$spansByOffset = [];
foreach ($operationsByOffset as $destOffset => $operation) {
    if ($destOffset != ($previousDestOffset + 4)) {
        $currentSpanStartOffset = $destOffset;
    }

    if (!isset($spansByOffset[$currentSpanStartOffset])) {
        $spansByOffset[$currentSpanStartOffset] = [];
    }

    $spansByOffset[$currentSpanStartOffset][] = $operation;

    $previousDestOffset = $destOffset;
}


foreach ($spansByOffset as $destOffset => $operations) {
    $instructions[] = sprintf(
        'lea %s(a0),a1',
        $destOffset
    );

    // get unique values
    $valueUsageCounts = [];
    foreach ($operations as $operation) {
        $operationValue = $operation['value'];
        if (!isset($valueUsageCounts[$operationValue])) {
            $valueUsageCounts[$operationValue] = 0;
        }
        $valueUsageCounts[$operationValue]++;
    }

    $filteredValueUsageCounts = [];
    foreach ($valueUsageCounts as $operationValue => $usageCount) {
        if ($usageCount > 1) {
            $filteredValueUsageCounts[$operationValue] = $usageCount;
        }
    }
    arsort($filteredValueUsageCounts);

    if (count($filteredValueUsageCounts) > 7) {
        $filteredValueUsageCounts = array_slice($filteredValueUsageCounts, 0, 7, true);
    }

    $registerIndex = 0;
    $valueRegisters = [];
    foreach ($filteredValueUsageCounts as $operationValue => $usageCount) {
        $mnemonic = 'move';
        if ($operationValue == '0' || $operationValue == 'ffffffff') {
            $mnemonic = 'moveq';
        }

        $instructions[] = sprintf(
            '%s.l #$%s,d%s',
            $mnemonic,
            $operationValue,
            $registerIndex
        );
        $valueRegisters[$operationValue] = $registerIndex;
        $registerIndex++;
    }

    foreach ($operations as $operation) {
        $operationMnemonic = $operation['operation'];
        $operationValue = $operation['value'];

        if (isset($valueRegisters[$operationValue])) {
            $firstParameter = 'd' . $valueRegisters[$operationValue];
        } else {
            if ($operationValue == '0' && $operationMnemonic == 'move') {
                $operationMnemonic = 'clr';
            }
            $firstParameter = '#$' . $operationValue;
        }

        if ($operationMnemonic == 'clr') {
            $instructions[] = 'clr.l (a1)+';
        } else {
            $instructions[] = sprintf(
                '%s.l %s,(a1)+',
                $operationMnemonic,
                $firstParameter,
            );
        }
    }
}

foreach ($instructions as $key => $instruction) {
    $instructions[$key] = '    ' . $instruction;
}

$instructionsContent = implode("\n", $instructions);
$result = file_put_contents($outputFilename, $instructionsContent);

if ($result === false) {
    echo("failed to write to file " . $outputFilename);
    exit(1);
}

echo("compiled sprite written to ".$outputFilename);
exit(0);

