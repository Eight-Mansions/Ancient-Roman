"""
Inserts files into DAT archives

Usage: <folder_of_translated_images> <original_dat> <output_archive>
"""

import sys
from pathlib import Path
import os

if len(sys.argv) < 3:
    print("Usage: <folder_of_translated_images> <output_directory>")
    exit()

input_directory = sys.argv[1]
output_directory = sys.argv[2]


def word_to_int(value):
    """
    Swaps the endianness of the byte sequence and returns the result as an integer
    """
    sequence_length = len(value)
    if sequence_length % 2 == 1:
        print("Cannot swap the endianness with partial bytes! Attempted: " + value)
        exit(1)

    hex_int = int(value, 16)
    return int.from_bytes(hex_int.to_bytes(sequence_length // 2, byteorder="little"),
                          byteorder="big", signed=False)


def process_folder(folder):
    for path in Path(folder).rglob("*"):
        if not path.is_file():
            continue

        if path.name.endswith(".bin") or path.name.endswith(".BIN"):
            process_dat(path)


def process_dat(archive_path):
    """
    Reads the original archive to determine the number of files and file sizes

    Header format is
     - # of images (4 bytes)
     - Pointer to image start (4 bytes per image)

    """
    with open(archive_path, "rb") as archive:
        raw_hex = archive.read().hex()
        images_in_archive = word_to_int(raw_hex[0:8])

        # Gather the pointers to the images and convert them to usable ints
        image_pointers = []
        for x in range(1, images_in_archive + 1):
            index = (x * 8)
            image_pointers.append(word_to_int(raw_hex[index:index + 8]))

        # The image data starts after the header. The header length is 4 bytes per pointer plus
        # 4 bytes for the number of entries.
        image_data_start = (images_in_archive * 4) + 4

        output_bytes = bytearray()
        output_pointers = []

        # Iterate through the images and add them to the archive
        for index, pointer in enumerate(image_pointers):
            # The decompressor outputs in the format of "TITLE.DAT-0x25e50.TIM"
            filename = str(archive_path) + "[" + str(index) + "].tim"
            pointer_image = Path(filename)

            # If this image is not one we've translated, add it as-is
            if not pointer_image.is_file():
                pointer_end = len(raw_hex)
                if index < len(image_pointers) - 1:
                    pointer_end = image_pointers[index + 1]
                image_bytes = raw_hex[pointer * 2:pointer_end * 2]
                output_pointers.append(int(len(output_bytes)) + image_data_start)
                output_bytes += bytes.fromhex(image_bytes)

            # Reinsert translated images
            else:
                print("Image found for index " + str(index) + ", adding:")
                with open(pointer_image, "rb") as image:
                    image_hex = image.read().hex()
                    output_pointers.append(len(output_bytes) + image_data_start)
                    output_bytes += bytes.fromhex(image_hex)

        # Create the output file and write out the header
        print("Outputting file to " + os.path.join(output_directory, str(archive_path)[len("images\\"):]))
        with open(os.path.join(output_directory, str(archive_path)[len("images\\"):]), "wb") as output:
            output.write(images_in_archive.to_bytes(4, "little"))

            for pointer in output_pointers:
                output.write(pointer.to_bytes(4, "little"))

            # Add the image data
            output.write(output_bytes)


process_folder(input_directory)
