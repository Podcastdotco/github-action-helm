FROM alpine:3

ENV KUBE_VERSION=1.19.3
ENV KUBE_URL=https://storage.googleapis.com/kubernetes-release/release/v$KUBE_VERSION/bin/linux/amd64/kubectl

ENV HELM_VERSION=3.3.4
ENV HELM_URL=https://get.helm.sh/helm-v$HELM_VERSION-linux-amd64.tar.gz

ENV IAM_URL=https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/aws-iam-authenticator

RUN apk add --update --no-cache git openssh curl python3 py-pip

RUN curl -LO $KUBE_URL && \
    mv ./kubectl /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl

RUN curl -L $HELM_URL | tar xvz && \
    mv linux-amd64/helm /usr/local/bin/helm && \
    chmod +x /usr/local/bin/helm && \
    rm -rf linux-amd64

RUN pip install awscli

RUN curl -o aws-iam-authenticator $IAM_URL && \
    mv ./aws-iam-authenticator /usr/local/bin/aws-iam-authenticator && \
    chmod +x /usr/local/bin/aws-iam-authenticator

COPY --from=mikefarah/yq:3 /usr/bin/yq /usr/bin/yq

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
