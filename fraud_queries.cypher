
// Load synthetic fraud data from uploaded CSV file
LOAD CSV WITH HEADERS FROM 'file:///synthetic_fraud_data.csv' AS row
MERGE (a1:Account {id: row.account_id})
MERGE (a2:Account {id: row.to_account_id})
MERGE (d:Device {id: row.device_id})
MERGE (e:Email {address: row.email})
MERGE (t:Transaction {id: row.tx_id})
MERGE (a1)-[:USED]->(d)
MERGE (a1)-[:REGISTERED_WITH]->(e)
MERGE (a1)-[:SENT]->(t)
MERGE (t)-[:TO]->(a2)
