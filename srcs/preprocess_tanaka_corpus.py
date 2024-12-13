import argparse
from sklearn.model_selection import train_test_split

def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('--input_file')
    parser.add_argument('--output_dir')
    args = parser.parse_args()
    return args

def main():
    args = parse_args()

    ja_sentences = []
    en_sentences = []

    with open(args.input_file, 'r', encoding='utf-8') as file:
        lines = [line.strip() for line in file]

    for l in lines:
        if l.startswith("B: "):
            continue
        l = l.replace("A: ","");
        ja_sentences.append(l.split("\t")[0])
        en_sentences.append(l.split("\t")[1].split("#ID=")[0])

    with open(f"{args.output_dir}/examples.ja", "w", encoding = "utf-8") as f_ja, open(f"{args.output_dir}/examples.en", "w", encoding = "utf-8") as f_en:
        for ja_sentence, en_sentence in zip(ja_sentences, en_sentences):
            f_ja.write(f"{ja_sentence}\n")
            f_en.write(f"{en_sentence}\n")

if __name__=="__main__":
    main()