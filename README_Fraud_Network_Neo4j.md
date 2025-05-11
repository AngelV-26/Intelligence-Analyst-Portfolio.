
# 🕵️‍♂️ Fraud Network Analysis with Neo4j & Cypher

This project demonstrates how to use **graph databases** and the **Cypher query language** to detect and analyze **fraud networks**, such as synthetic identity fraud, using Neo4j.

Furthermore, it simulates real-world fraud detection using graph databases. It models how accounts, devices, and emails relate, using Neo4j to uncover fraud rings, synthetic identities, and transaction laundering.

## 📌 Objective
Model relationships between accounts, devices, emails, and transactions to uncover suspicious behavior, such as shared infrastructure or circular money flow between entities.

## 🛠️ Tools & Technologies
- **Neo4j Aura** (cloud graph DB)
- **Cypher Query Language**
- Optional: Python for automation using `neo4j` driver

## 📊 Graph Data Model

```
(:Account)-[:USED]->(:Device)
(:Account)-[:REGISTERED_WITH]->(:Email)
(:Account)-[:SENT]->(:Transaction)-[:TO]->(:Account)
```

## 🗃️ Dataset (Sample CSV)
Place this under `/data/synthetic_fraud_data.csv`:

| account_id | email        | device_id | to_account_id | tx_id |
|------------|--------------|-----------|---------------|--------|
| A001       | a1@mail.com  | D001      | A002          | TX01   |
| A002       | a2@mail.com  | D002      | A003          | TX02   |
| A003       | a3@mail.com  | D001      | A001          | TX03   |

---

## 🔧 Setup Instructions (Neo4j Aura)

1. **Login to Neo4j Aura** and create a new free instance.
2. In the left sidebar, go to `Import` → Upload `synthetic_fraud_data.csv`.
3. Open the Neo4j Browser and paste the following Cypher to load your data:

```cypher
LOAD CSV WITH HEADERS FROM 'https://<YOUR_AURA_URL>/synthetic_fraud_data.csv' AS row
MERGE (a1:Account {id: row.account_id})
MERGE (a2:Account {id: row.to_account_id})
MERGE (d:Device {id: row.device_id})
MERGE (e:Email {address: row.email})
MERGE (t:Transaction {id: row.tx_id})
MERGE (a1)-[:USED]->(d)
MERGE (a1)-[:REGISTERED_WITH]->(e)
MERGE (a1)-[:SENT]->(t)
MERGE (t)-[:TO]->(a2)
```

---

## 🔍 Sample Threat Detection Queries

### 🔁 Shared Device Usage (Red Flag for Synthetic Fraud)
```cypher
MATCH (a1:Account)-[:USED]->(d:Device)<-[:USED]-(a2:Account)
WHERE a1.id <> a2.id
RETURN a1.id, a2.id, d.id
```

### 🔁 Circular Transactions (Suspicious Movement)
```cypher
MATCH path = (a1:Account)-[:SENT]->(:Transaction)-[:TO]->(a2:Account)-[:SENT]->(:Transaction)-[:TO]->(a1)
RETURN path
```

---

## 📸 Visual Output
Include screenshots of:
- Graph showing accounts connected by shared devices
- Circular money paths from transaction loops

---

## 🧠 Use Cases
- Detect **synthetic identity rings**
- Analyze **fraudulent device sharing**
- Trace **transaction laundering loops**

---

## 🔄 Future Enhancements
- Add risk scoring for each account
- Integrate Python to automate uploads and queries
- Detect known MITRE ATT&CK patterns (TTPs)

---

## 📜 License
MIT License
