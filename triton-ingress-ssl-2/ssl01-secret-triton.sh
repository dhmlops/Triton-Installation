PRIVATE_KEY=../CA/ca.unencrypted.key
PUBLIC_CERT=../CA/ca.pem
SECRET_NAME=ca-key-pair-triton-2
NS=triton-2

kubectl create secret tls $SECRET_NAME -n $NS --cert=$PUBLIC_CERT --key=$PRIVATE_KEY
