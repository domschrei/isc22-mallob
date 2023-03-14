################### Build Mallob
FROM mallob-calrat-proof:base AS builder
USER root
#  Install required softwares

################### Extract Mallob in run stage
FROM satcomp-base:worker AS mallob_liaison
RUN whoami
USER root
RUN DEBIAN_FRONTEND=noninteractive apt install -y libjemalloc-dev libjemalloc2 gdb psmisc
RUN mkdir /logs
RUN chown ecs-user /logs

USER ecs-user
WORKDIR /
# Copy mallob
COPY --from=builder /mallob/build/mallob mallob
COPY --from=builder /mallob/build/mallob_sat_process mallob_sat_process
COPY --from=builder /mallob/build/mallob_process_dispatcher mallob_process_dispatcher
COPY --chown=ecs-user /worker /competition
COPY --chown=ecs-user /cleanup /competition

RUN chmod +x /competition/worker
RUN chmod +x /competition/cleanup

RUN mkdir -p /logs/processes
RUN mkdir -p /logs/extmem
RUN mkdir -p /logs/tracedir
