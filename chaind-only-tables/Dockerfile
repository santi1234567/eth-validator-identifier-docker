FROM wealdtech/chaind

COPY chaind-only-tables-wrapper.sh .

RUN chmod +x chaind-only-tables-wrapper.sh

ENTRYPOINT [ "./chaind-only-tables-wrapper.sh" ]