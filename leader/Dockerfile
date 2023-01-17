################### Build Mallob
FROM mallob-calrat-proof:base AS builder
USER root
#  Install required softwares


################### Extract Mallob in run stage
FROM satcomp-base:leader AS mallob_liaison
RUN whoami
USER root
RUN DEBIAN_FRONTEND=noninteractive apt install -y libjemalloc-dev libjemalloc2 gdb psmisc
RUN apt-get update && apt install -y libboost-all-dev

USER ecs-user
WORKDIR /
# Copy mallob and solver scripts
COPY --from=builder /mallob/build/mallob mallob
COPY --from=builder /mallob/build/mallob_sat_process mallob_sat_process
COPY --from=builder /mallob/build/mallob_process_dispatcher mallob_process_dispatcher
COPY --chown=ecs-user /run_mallob.sh /competition
COPY --from=builder /drat-trim/lrat-check lrat-check
COPY --from=builder /drat-trim/compress compress
COPY --from=builder /drat-trim/decompress decompress
COPY --from=builder /drat-trim/drat-trim drat-trim
COPY --from=builder /preprocess-simple/cleanup preprocess-cnf
COPY --from=builder /mallob/tools/composition/build/compose-proofs compose-proofs 
COPY --from=builder /mallob/tools/composition/build/renumber-proofs renumber-proofs
COPY --from=builder /mallob/tools/composition/build/dratify dratify
COPY --chown=ecs-user compress_preprocessing_proof.sh /competition
COPY --chown=ecs-user proof_line_count.sh /competition
COPY --chown=ecs-user proof_compose.sh /competition
COPY --chown=ecs-user proof_renumber.sh /competition
COPY --chown=ecs-user proof_check.sh /competition
COPY --chown=ecs-user preprocess_cnf.sh /competition
COPY --chown=ecs-user drat_compose.sh /competition
COPY --chown=ecs-user solver /competition
COPY --chown=ecs-user cleanup /competition
# COPY --chown=ecs-user /instances/r3unsat_200.cnf /competition/test.cnf
# COPY --chown=ecs-user /instances/r3unsat_300.cnf /competition/test2.cnf

USER root
RUN chmod +x /competition/cleanup
RUN chown ecs-user /
RUN chmod 777 /

RUN mkdir /logs
RUN chown ecs-user /logs
USER ecs-user
RUN chmod 777 /logs


USER ecs-user
RUN chmod +x /competition/run_mallob.sh
RUN chmod +x /competition/solver
RUN chmod +x /competition/proof_line_count.sh
RUN chmod +x /competition/compress_preprocessing_proof.sh
RUN chmod +x /competition/proof_compose.sh
RUN chmod +x /competition/proof_renumber.sh
RUN chmod +x /competition/proof_check.sh
RUN chmod +x /competition/drat_compose.sh

