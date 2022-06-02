cd CREATION/SCRIPTS &&

python3 people.py &&
python3 skill.py &&
python3 casting.py &&
python3 skill_needed.py &&
python3 rejected.py &&
python3 contract.py &&
python3 amendment.py &&
python3 money.py &&

mv agent_contract.csv ../CSV/agent_contract.csv &&
mv agent.csv ../CSV/agent.csv &&
mv amendment.csv ../CSV/amendment.csv &&
mv artist.csv ../CSV/artist.csv &&
mv casting.csv ../CSV/casting.csv &&
mv claim.csv ../CSV/claim.csv &&
mv payment.csv ../CSV/payment.csv &&
mv people_skill.csv ../CSV/people_skill.csv &&
mv producer_contract.csv ../CSV/producer_contract.csv &&
mv producer.csv ../CSV/producer.csv &&
mv rejected.csv ../CSV/rejected.csv &&
mv skill_needed.csv ../CSV/skill_needed.csv
