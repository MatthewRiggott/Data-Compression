#Data-Compression

Ruby Version: 2.0+

This was done as a curious learning exercise to understand how compression works.  This script compresses text data using the Huffman Compression Algorithm.  [Further Explained](https://en.wikipedia.org/wiki/Huffman_coding) or read below for more understanding.

To run.
Clone repo.
Navigate to directory.
`ruby data-compression -/path/to/my/file -U(decompress) or -C(compress)`

The first step is to build a frequency chart for characters in the text being compressed.  Then using this, you can build a tree starting from the left to right assigning the more frequent values to the left side.  Once the tree is constructed, bit values are assigned to characters.  For each 'left' turn you take down a branch add a "0".  Each 'right' turn assigned is a '1'.  This means the highest frequency characters have a very low byte value as they are on the left side (more left turns than right) and vice versa, the lesser occurring chars will have much higher bit values.

Starting with this small test File.  We notice there is many T's.  We expect 'T' to consequently have a low byte value.

![Picture of text to be compressed](http://i.imgur.com/BIgAzpI.png)


`ruby data-compression -/test-text/test.txt -C` to compress.

This is the compressed output with a header for the program to decompress.  As we expected the bit value for 'T' (highest frequency character) is 0000 as seen in the header.

![Picture of compressed text](http://i.imgur.com/7BZb6dz.png)


`ruby data-compression -/test-text/test.txt.compressed -U` to decompress.

Using the header as a hash, the script parses the bits and fills the original back in character by character.

![Picture of decompressed text](http://i.imgur.com/BIgAzpI.png)

The downside to this method is that because of the header, when compressing smaller files the gains are minimal due the necessity of attaching a "decoder" heading to the file.  This is offset when the original file is so large that the memory to include a heading is negligible.
