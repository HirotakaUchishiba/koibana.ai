# [WIP] koibana.ai

## Setup

### Server

いかに API server(fast api)にプロンプトを投げて応答を得る流れを示す．

1. パッケージをインストール

```sh
cd server
pip install -r requierments.txt
```

2.  `.env`ファイルを作る(岩田さんから環境変数を貰って記入する)

```sh
touch .env
```

3. ocalhost:8000 を立ち上げる

```sh
cd app
uvicorn main:app --reload

#別のターミナルで動作を確認する
curl localhost:8000
```

4.  LLM を動かして応答を得る. json 形式でクエリを渡す

```sh
curl -N -X POST -H "Accept: text/event-stream" -H "Content-Type: application/json" -d '{"query": "あなたは誰ですか？？"}' http://localhost:8000/chat

>>>

私はAIです。具体的には、OpenAIのGPT-3という自然言語処理モデルを使用しています。あなたのお役に立てることがあれば、何でもおっしゃってください。%
```

<!-- # curl -N -X POST \ ─╯
# -H "Accept: text/event-stream" -H "Content-Type: application/json" \
# -d '{"query": "あなたは誰ですか？？"}' \
# http://localhost:8000/chat -->
