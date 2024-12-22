FROM gcc:latest AS builder

WORKDIR /server

RUN apt-get update && apt-get install -y git g++ make autoconf  

RUN git clone https://github.com/DianaRozhko/Lab3_DevOps.git . 
RUN git checkout branchHTTPserver 
RUN autoreconf -i 
RUN ./configure 
RUN make

RUN ls -l /server

FROM alpine:latest
RUN apk add --no-cache libstdc++ libc6-compat

WORKDIR /server

COPY --from=builder /server/server .


CMD ["./server"]
