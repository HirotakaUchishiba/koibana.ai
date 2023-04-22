# [WIP] koibana.ai
## Setup
### Server
```sh
# パッケージをインストール
cd server
pip install -r requierments.txt

# 動かす
cd app
uvicorn main:app --reload
# ↑こうすると localhost:8000 が立ち上がるので
# ↓こうするとレスポンスが返ってくる
curl localhost:8000
```
