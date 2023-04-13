FROM wealdtech/chaind

COPY chaind-wrapper.sh .

RUN chmod +x chaind-wrapper.sh

ENTRYPOINT [ "./chaind-wrapper.sh" ]