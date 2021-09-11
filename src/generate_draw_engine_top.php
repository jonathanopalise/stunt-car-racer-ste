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

$inputFilename = 'engine_top.bin';
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
    $colourLongs[] = readLongword($data, $offset);
    $colourLongs[] = readLongword($data, $offset+4);
    $offset += 10;
}

$offsetsByMaskword = [];
foreach ($maskWords as $offset => $maskWord) {
    if (!isset($offsetsByMaskWord[$maskWord])) {
        $offsetsByMaskWord[$maskWord] = [];
    }
    echo("adding ".$offset." to ".$maskWord."\n");
    $offsetsByMaskWord[$maskWord][] = $offset;
}

echo("number of mask words: ".count($maskWords)."\n");
echo("number of unique mask words: ".count($offsetsByMaskWord)."\n");

$instructions = [];
$handledMaskWords = [];
$maskWordsOffset = 0;
$destOffset = 0;
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

foreach ($instructions as $instruction) {
    echo($instruction."\n");
}
