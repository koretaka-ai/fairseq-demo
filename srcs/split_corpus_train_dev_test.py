import argparse
import numpy as np

def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('--input_file_prefix')
    parser.add_argument('--output_dir')
    parser.add_argument('--src_lang', default="en")
    parser.add_argument('--tgt_lang', default="ja")
    parser.add_argument('--num_dev', type=int, default=2000)
    parser.add_argument('--num_test', type=int, default=2000)
    parser.add_argument('--seed', type=int, default=42)
    args = parser.parse_args()
    return args

def main():
    args = parse_args()

    # read file and convert type
    with open(f"{args.input_file_prefix}.{args.src_lang}") as src_fin, open(f"{args.input_file_prefix}.{args.tgt_lang}") as tgt_fin:
        all_src = src_fin.readlines()
        all_tgt = tgt_fin.readlines()
        all_src = np.array(all_src, dtype=object)
        all_tgt = np.array(all_tgt, dtype=object)

    # random
    np.random.seed(args.seed)
    shuffled_ids = np.random.permutation(len(all_src))

    # split
    train_ids = shuffled_ids[args.num_dev + args.num_test:]
    train_src = all_src[train_ids]
    train_tgt = all_tgt[train_ids]
    dev_ids = shuffled_ids[:args.num_dev]
    dev_src = all_src[dev_ids]
    dev_tgt = all_tgt[dev_ids]
    test_ids = shuffled_ids[args.num_dev:args.num_dev+args.num_test]
    test_src = all_src[test_ids]
    test_tgt = all_tgt[test_ids]

    # write train
    with open(f"{args.output_dir}/train.{args.src_lang}", mode='w') as src_fout, open(f"{args.output_dir}/train.{args.tgt_lang}", mode='w') as tgt_fout:
        src_fout.writelines(list(train_src))
        tgt_fout.writelines(list(train_tgt))

    # write dev
    with open(f"{args.output_dir}/dev.{args.src_lang}", mode='w') as src_fout, open(f"{args.output_dir}/dev.{args.tgt_lang}", mode='w') as tgt_fout:
        src_fout.writelines(list(dev_src))
        tgt_fout.writelines(list(dev_tgt))

    # write test
    with open(f"{args.output_dir}/test.{args.src_lang}", mode='w') as src_fout, open(f"{args.output_dir}/test.{args.tgt_lang}", mode='w') as tgt_fout:
        src_fout.writelines(list(test_src))
        tgt_fout.writelines(list(test_tgt))

if __name__ == '__main__':
    main()
