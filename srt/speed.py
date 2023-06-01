from datetime import datetime, timedelta
import srt
import sys

def generate_subs(subtitles_file, output_file):
    with open(subtitles_file, 'r') as f:
        subs = list(srt.parse(f.read()))

    new_subs = []
    index = 1

    for sub in subs:
        start = sub.start
        end = sub.end
        duration = end - start
        words = sub.content.split()

        if len(words) == 0:
            continue

        increment = duration / len(words)
        current_time = start

        for word in words:
            current_end_time = current_time + increment
            new_subs.append(srt.Subtitle(index, current_time, current_end_time, word))
            current_time = current_end_time
            index += 1

    with open(output_file, 'w') as f:
        f.write(srt.compose(new_subs))


if __name__ == '__main__':
    if len(sys.argv) != 3:
        print('Usage: python3 script.py <input_srt_file> <output_srt_file>')
        sys.exit(1)
    
    subtitles_file = sys.argv[1]
    output_file = sys.argv[2]
    generate_subs(subtitles_file, output_file)
