FROM circleci/golang:stretch as builder
RUN git clone https://github.com/koalaman/shellcheck.git ./build/
RUN sudo apt-get update \
      && sudo apt-get upgrade -y \
      && sudo apt-get install -y cabal-install \
      && sudo apt-get clean
WORKDIR ./build/
RUN cabal update \
      && cabal install

FROM circleci/golang:stretch
RUN sudo apt-get update \
      && sudo apt-get upgrade -y \
      && sudo apt-get install -y awscli \
      && sudo apt-get clean

RUN go get -u github.com/tcnksm/ghr
COPY --from=builder /home/circleci/.cabal/bin/shellcheck /usr/local/bin/
COPY ./bin/ /usr/local/bin/
