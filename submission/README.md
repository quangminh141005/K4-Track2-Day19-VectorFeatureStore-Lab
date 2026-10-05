# Required submission — NB1–NB4

Completed on the lite path, with `BAAI/bge-small-en-v1.5` (384 dimensions),
in-memory Qdrant, BM25, RRF k=60, and Feast SQLite/file stores.
Advanced NB5–NB8 and the bonus challenge are excluded from this submission.

The four executed `.ipynb` files are in `notebooks/`; all code cells executed
without errors. `screenshots/` contains browser captures of HTML transcripts
extracted from those notebook outputs, with terminal color codes removed.

| Requirement | Observed result |
|---|---|
| NB1 vector count | 1,000 |
| NB1 Vietnamese paraphrase | 5/5 top results in cloud topic |
| NB2 Precision@10 | BM25 77.8%; semantic 73.2%; hybrid 78.6% |
| NB2 mixed slice | Hybrid 100.0% |
| NB3 hybrid server-side P99 | 24.4 ms, 100 measured calls after warm-up |
| NB4 views | user_profile_features, item_popularity_features, query_velocity_features |
| NB4 online lookup P99 | 1.41 ms across 100 lookups |
| NB4 materialized entities | 100 profiles; 100 query velocities; 1,000 items |
| NB4 PIT join | 3 rows with reading speed and topic affinity |
| Repository checks | 41 tests passed; lite smoke check passed |
| Full benchmark | 5,000 calls/mode; hybrid P99 23.7 ms; quality assertion passed |

Reproduce in a standard Python environment:

```bash
bash setup-lite.sh
make notebooks-core
make test verify-lite benchmark
```

This workspace used the existing Conda environment instead:

```bash
make VENV=/home/qminh/miniconda3/envs/env_vinai_lab notebooks-core
make VENV=/home/qminh/miniconda3/envs/env_vinai_lab test verify-lite benchmark
```

Before LMS submission, replace the GitHub username in `REFLECTION.md` with
your full name and confirm your cohort. Push the required files to your public
GitHub repository and paste its URL into the Day-19 LMS submission box.
