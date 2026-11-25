# Developing Applications with Apache Spark

Databricks Academy course *Developing Applications with Apache Spark* (ASP 2, v3.0.1), set up to be
**edited in VS Code and executed on Azure Databricks**. It is the follow-on to
*Introduction to Apache Spark*: DataFrame transformations, grouping, aggregation and window functions,
joins and set operations, and complex types (arrays, structs, maps, JSON). Clone the repo, run one script,
and the notebooks run in your own workspace. My notes are in [NOTES.md](NOTES.md).

| Section | Contents |
|---|---|
| [00_Course_Overview](00_Course_Overview.ipynb) | Objectives, prerequisites, agenda |
| [01_Demo_Required_Setup](01_Demo_Required_Setup.ipynb) | **Run once first**: `spark_dev` schema, `raw_customer_profiles` and `raw_franchise_sales` (JSON-string tables built from Bakehouse) |
| [1_DataFrame_API_Basics](1_DataFrame_API_Basics/) | 1.1 lecture, 1.2 optional ETL demo |
| [2_Grouping_and_Aggregating_Data](2_Grouping_and_Aggregating_Data/) | 2.1 lecture, 2.2 demo on `samples.nyctaxi`, 2.3 lab on Bakehouse sales |
| [3_DataFrame_Relational_Operations](3_DataFrame_Relational_Operations/) | 3.1 lecture, 3.2 demo: joins and set operations over the Bakehouse tables |
| [4_Working_with_Complex_Data](4_Working_with_Complex_Data/) | 4.1 lecture, 4.2 demo, 4.3 lab: arrays, structs, maps, JSON |

---

## Quick start

**Prerequisites**
- Azure Databricks workspace with **Unity Catalog** (Premium tier)
- Permission to create a catalog (`labuser_<you>`, shared with the other course repos) and a cluster
- Linux, macOS or WSL with `bash`, `curl`, `unzip`, `python3`
- VS Code with the **Databricks** extension (on WSL: install it *in WSL*)
- No Marketplace datasets: the course reads the built-in `samples` catalog (`bakehouse`, `nyctaxi`)

**Setup**

```bash
cd Developing_Applications_with_Apache_Spark
./setup.sh
```

`setup.sh` is safe to re-run. It:
1. installs the Databricks CLI and `uv` into `~/.local/bin` if missing (no sudo);
2. logs in to your workspace (OAuth, profile `azure-de`), asking for the workspace URL once, and writes
   it to the git-ignored `databricks.local.yml` (the VS Code extension needs it in the bundle);
3. creates `.venv` (Python 3.12) with Databricks Connect 17.3 (must match the cluster's DBR; also works on serverless);
4. creates your course catalog `labuser_<you>`, checks `samples`, and writes `<default catalog>.ops.meta_spark_dev`;
5. creates the classic cluster **Developing Apps with Apache Spark (&lt;you&gt;)** (DBR 17.3 LTS, dedicated,
   1 worker, `Standard_D4ds_v5`, auto-terminates after 30 min), terminates it right away, and adds its ID to
   `databricks.local.yml` so the VS Code extension uses it;
6. writes `.env` for local runs, pointing Databricks Connect at that cluster, and `.databricks/.databricks.env`
   so local notebook kernels get `spark`, `dbutils` and `display`;
7. syncs the course to `/Workspace/Users/<you>/.bundle/developing-applications-with-apache-spark-course/dev/files`.

**Run the course**
1. In the workspace, **Compute → Developing Apps with Apache Spark (&lt;you&gt;) → Start**.
2. Open the synced `01_Demo_Required_Setup`, attach the cluster, **Run all** (once).
3. Work through the sections; demos and labs call `ensure_setup()` and switch to `spark_dev`.

Labs (2.3, 4.3) contain `FILL_IN` exercises with expandable solutions and are not expected to run unmodified.

### Classic cluster or serverless?

The course asks for a **classic cluster on DBR 17.3 LTS**, because some demos refer to the Spark UI and
query plans. All demos also run on **serverless** (notebooks are pinned to environment version 4 =
Spark 4.0 / Python 3.12); you just don't get the Spark UI there.

---

## Status

| Check | Result |
|---|---|
| All `%run` targets and `$./` notebook links resolve after renaming | ✅ |
| `setup.sh` end to end | ✅ |
| `01_Demo_Required_Setup` → `Version_Info` (serverless job run) | ✅ |
| Demos 1.2, 2.2, 3.2, 4.2 (serverless job run) | ✅ |
| Demos on the classic cluster (Spark UI) | not yet tested |

---

## Repository layout

```
.
├── setup.sh              # One-shot setup (tools, login, .venv, UC bootstrap, cluster, .env, sync)
├── databricks.yml        # Databricks Asset Bundle: syncs the repo to the workspace
├── databricks.local.yml  # (git-ignored, written by setup.sh) your workspace host
├── .env.example          # Template for .env (setup.sh fills it in)
├── .vscode/settings.json # .venv interpreter, notebook working dir, Databricks cell markers
├── scripts/
│   ├── set_serverless_env.py   # Pin notebooks to a serverless environment version
│   ├── static_code_blocks.py   # Pre-render JS code blocks so they show in VS Code
│   └── static_widgets.py       # Quizzes, flip cards, tabs as static HTML for VS Code
├── NOTES.md, Version_Info.ipynb
├── 00_Course_Overview.ipynb, 01_Demo_Required_Setup.ipynb
├── 1_DataFrame_API_Basics/              # Section_Overview + 1.1, 1.2
├── 2_Grouping_and_Aggregating_Data/     # Section_Overview + 2.1 … 2.3
├── 3_DataFrame_Relational_Operations/   # Section_Overview + 3.1, 3.2
├── 4_Working_with_Complex_Data/         # Section_Overview + 4.1 … 4.3
└── Includes/             # Classroom-Setup-*.sql (%run by the demos/labs), _common.py
```

---

## How the course was adapted to a regular workspace

| Change | Where | Why |
|---|---|---|
| Course folder flattened into the repo root, top-level `Includes/` merged in, names with spaces/colons/` - ` → underscores, all `%run` and `$./` links updated | all | Same conventions as the other course repos; paths with spaces are awkward in shells and links |
| `.sql`/`.py` source notebooks → `.ipynb` (workspace exporter) | lessons, `Version_Info` | Same as the other repos. `Includes/*` stay source files (`%run` targets) |
| Serverless environment v4 in notebook metadata | all `.ipynb` | Matches DBR 17.3 / Spark 4.0 when a notebook runs on serverless |
| `"0 - Required Setup"` → `01_Demo_Required_Setup` in text and the `ensure_setup()` error | `Includes/Classroom-Setup-Common.sql`, notebooks | Points at the notebook's actual name |
| JavaScript in `%md-sandbox` cells → static HTML: Prism code blocks pre-highlighted (`scripts/static_code_blocks.py`); multiple-choice and true/false knowledge checks, flip cards and Spark UI tabs rewritten with *Show answer* / *Click for more* folds (`scripts/static_widgets.py`) | lectures, labs, 1.3 demo | VS Code doesn't run scripts in markdown, so code collapsed into plain text and quizzes rendered empty; now they look the same in VS Code and Databricks (no score counter, light/dark toggle or Copy button) |
| `restartPython()` only on Databricks | `Includes/_common.py` | `dbutils.library` does not exist over Databricks Connect |
| `DBAcademyHelper` reads `<default catalog>.ops.meta_spark_dev` (was `ops.meta` under `dbacademy`) | `Includes/_common.py`, created by `setup.sh` | `dbacademy` only exists in Academy labs; own table so the other repos' `ops.meta*` aren't overwritten |
| `labuser_<you>` created by `setup.sh` with a `MANAGED LOCATION` | `setup.sh` | The metastore has no storage root, so `Classroom-Setup-Common`'s plain `CREATE CATALOG` would fail; it now finds the catalog existing |
| Classic DBR 17.3 cluster created by `setup.sh` | `setup.sh` | The course requires it for the Spark UI references |
| Dropped `Includes/QC Automation/` and the course `.gitignore`/`README.md` | — | Academy-internal test runner (writes to `dbacademy`) and authoring files |

---

## Where to run what

| Notebook content | Local (VS Code + Databricks Connect) | Serverless | Classic cluster |
|---|:-:|:-:|:-:|
| Python/PySpark cells in the labs | ✅ (after setup in the workspace; set the schema yourself) | ✅ | ✅ |
| `01_Demo_Required_Setup`, SQL-language demos, `%run` Classroom-Setup | ❌ | ✅ | ✅ |
| Spark UI exploration | ❌ | ❌ | ✅ |

Rule of thumb: **edit locally, run the lessons in the workspace** (from the synced bundle folder).

---

## Troubleshooting

| Symptom | Cause | Fix |
|---|---|---|
| `Required setup has not been completed` | Setup notebook not run in this catalog | Run `01_Demo_Required_Setup` once |
| `UC_METASTORE_STORAGE_ROOT_URL_NOT_FOUND_WITH_DEFAULT_STORAGE` in Classroom Setup | `labuser_<you>` doesn't exist yet, so the notebook tried a plain `CREATE CATALOG` | Run `./setup.sh` (creates it with a managed location) |
| `Metadata table <catalog>.ops.meta_spark_dev not found` (Version_Info) | Workspace not bootstrapped | Run `./setup.sh` |
| No Spark UI link | Notebook is on serverless | Attach the **Developing Apps with Apache Spark** cluster |
| Cluster creation failed in `setup.sh` | No cluster-create permission, or node type unavailable | Create one in **Compute**: Dedicated access, 17.3 LTS, then re-run (it is detected by name) |
| VS Code: Databricks sidebar never logs in; `UrlError: Invalid host name` | No `workspace.host` in the bundle | Run `./setup.sh`, then **Developer: Reload Window** |
| Local run: `default auth: metadata-service ... Connection refused` | The extension's auth helper moved to a new port | `DATABRICKS_AUTH_TYPE=databricks-cli` in `.env` (setup.sh writes it); restart the kernel |
| Local run: `cannot configure default credentials`, OAuth token expired | CLI login expired | `databricks auth login -p azure-de` |
| Local notebook: `NameError: name 'spark' is not defined` | No `.databricks/.databricks.env`, so the Databricks extension's IPython startup script skips creating `spark` | Run `./setup.sh` (writes it), or connect the Databricks extension; then restart the kernel. Needs the extension installed (it provides the startup script) |
| Local run on the cluster: version or protocol mismatch error | `databricks-connect` newer than DBR 17.3 | `uv pip install --python .venv "databricks-connect==17.3.*"` (setup.sh pins it) |
| Local run is slow to start | `.env` targets the cluster, which starts on first use | Wait a few minutes, or switch `.env` to serverless (see the comment there) |

---

## Credits

Course notebooks and setup scripts are from **Databricks Academy** (© Databricks, Inc. All rights
reserved), with the adaptations listed above. Notes, `setup.sh`, configuration and scripts are my own.
