ARG BUILDPLATFORM=linux/amd64
FROM --platform=${BUILDPLATFORM} public.ecr.aws/ubuntu/ubuntu:22.04

# Update and install required packages in one RUN
RUN apt-get update -y && apt-get install -y wget unzip vim git curl jq python3 python3-pip && python3 -m pip install --upgrade pip

# Install Terraform 1.12.1
RUN wget https://releases.hashicorp.com/terraform/1.12.1/terraform_1.12.1_linux_amd64.zip && unzip terraform_1.12.1_linux_amd64.zip && mv terraform /usr/local/bin/ && \
    rm terraform_1.12.1_linux_amd64.zip

# Install TFLint
RUN curl -L "$(curl -s https://api.github.com/repos/terraform-linters/tflint/releases/latest | grep -o -E -m 1 "https://.+?_linux_amd64.zip")" -o tflint.zip && \
    unzip tflint.zip && \
    mv tflint /usr/bin/ && \
    rm tflint.zip

# Install Checkov via pip
RUN pip3 install --no-cache-dir checkov

# Install TFSEC
RUN curl -L "$(curl -s https://api.github.com/repos/aquasecurity/tfsec/releases/latest | grep -o -E -m 1 "https://.+?tfsec-linux-amd64")" -o tfsec && \
    chmod +x tfsec && \
    mv tfsec /usr/bin/

# Install OPA
RUN curl -L -o opa https://openpolicyagent.org/downloads/v0.52.0/opa_linux_amd64_static && chmod +x opa && mv opa /usr/bin/
