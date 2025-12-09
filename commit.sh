#!/bin/bash

echo "Digite a mensagem do commit:"
read msg

git add .
git commit -m "$msg"
git push

echo "✓ Commit e push enviados!"
