FROM debian:trixie

ENV PATH="/root/.local/bin:${PATH}"
WORKDIR /agy

COPY --chmod=755 src/container-config.sh .
RUN ./container-config.sh
COPY --chmod=755 entrypoint.sh .

COPY ag-bypass ./ag-bypass

WORKDIR /workspace

ENTRYPOINT ["/agy/entrypoint.sh"]
CMD ["agy", "--dangerously-skip-permissions"]