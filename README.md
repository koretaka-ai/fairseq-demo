# fairseqを用いた機械翻訳
- 仮想環境：uv
- pythonバージョン：3.10
- 内容：田中コーパスでJParaCrawl v3.0 baseモデルをfine-tuningし、BLEUとCOMETで評価。

# 一連の流れ

## 仮想環境の導入
- 仮想環境には[uv](https://docs.astral.sh/uv/getting-started/)を使用
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
source $HOME/.local/bin/env
```

## git clone
```bash
git clone https://github.com/koretaka-ai/fairseq-demo.git
cd fairseq-demo
```

## 仮想環境の構築
```bash
uv sync
. .venv/bin/activate
```

## 実行
```bash
bash scripts/exe.sh
```

