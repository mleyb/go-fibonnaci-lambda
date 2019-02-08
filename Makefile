build:
	go fmt
	go get -v
	golint -set_exit_status
	go vet .
	go test .
	# Lambda requires a Linux binary
	GOOS=linux go build -o main main.go

zip:
	# Create the deployment zip file
	zip deployment.zip main

invoke-func:
	aws lambda invoke --region=eu-west-1 --function-name=Fibonacci --log-type Tail --payload '7' output.txt

tf-apply:
	terraform apply

tf-destroy:
	terraform destroy