# https://pypi.org/project/sentencepiece/
import argparse
import sentencepiece as spm

def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('--model')
    parser.add_argument('--input')
    parser.add_argument('--output')
    args = parser.parse_args()
    return args

def main():
    args = parse_args()

    # read spm-model
    model = spm.SentencePieceProcessor(model_file=args.model)

    # apply spm model
    with open(args.input, "r") as fin, open(args.output, "w") as fout:
        for line in fin:
            line = " ".join(model.encode(line, out_type=str))
            fout.write(line + "\n")

if __name__ == '__main__':
    main()