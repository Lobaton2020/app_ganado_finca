const ddlTableOwners = '''
CREATE TABLE owners (
    id INTEGER PRIMARY KEY,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    name TEXT NOT NULL
);
''';
const ddlTableProvenances = '''
CREATE TABLE provenances (
    id INTEGER PRIMARY KEY,
    name TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
''';
const ddlTableBovines = '''
CREATE TABLE bovines (
    id INTEGER PRIMARY KEY,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    name TEXT NOT NULL,
    date_birth DATE NOT NULL,
    color TEXT NOT NULL,
    owner_id INTEGER NOT NULL,
    photo TEXT,
    mother_id INTEGER,
    is_male BOOLEAN NOT NULL,
    for_increase BOOLEAN NOT NULL DEFAULT false,
    adquisition_amount REAL,
    provenance_id INTEGER NOT NULL,
    FOREIGN KEY (owner_id) REFERENCES owners(id),
    FOREIGN KEY (provenance_id) REFERENCES provenances(id)
);
''';
const ddlTableBovinesOutput = '''
CREATE TABLE bovines_output (
    id INTEGER PRIMARY KEY,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    was_sold BOOLEAN NOT NULL,
    evidence_photo TEXT,
    sold_amount REAL,
    description TEXT,
    bovine_id INTEGER NOT NULL,
    FOREIGN KEY (bovine_id) REFERENCES bovines(id)
);
''';
