const dmlTableProvenance = '''
    INSERT INTO provenances ("name", created_at)
    VALUES
        ('Compra', '2024-01-13 15:49:36'),
        ('Nacimiento', '2024-01-13 15:49:47'),
        ('Regalo', '2024-01-13 15:50:02');
''';
const dmlTableOwners = '''
INSERT INTO owners (created_at, "name")
VALUES
    ('2024-01-13 15:34:07', 'Carmen'),
    ('2024-01-13 15:34:17', 'Mariela'),
    ('2024-01-13 15:34:24', 'Ivan'),
    ('2024-01-13 15:34:55', 'Abuelo Pedro'),
    ('2024-01-13 15:34:32', 'Andres'),
    ('2024-01-13 15:35:28', 'Numa');
''';
const dmlTableBovines = '''
INSERT INTO bovines (
    created_at,
    "name",
    date_birth,
    color,
    owner_id,
    photo,
    mother_id,
    is_male,
    for_increase,
    adquisition_amount,
    provenance_id
)
VALUES
    (
        '2024-01-13 16:01:25',
        'Vaca mia regalo ama',
        '2021-05-03',
        'Amarillo',
        4,
        'https://th.bing.com/th/id/R.28e966a5df182f2f86c2b32e1126c320?rik=TaTTHTXgwQXTGA&riu=http%3a%2f%2fupload.wikimedia.org%2fwikipedia%2fcommons%2f4%2f4d%2fArzua._A_Castanheda._Galiza._vaca.jpg&ehk=gprrPIMCv52as1Eitc76Fg6uFzwfiY%2fJDtdt1WZRnGs%3d&risl=1&pid=ImgRaw&r=0',
        NULL,
        false,
        false,
        NULL,
        3
    ),
    (
        '2024-01-13 16:03:05',
        'Becerro bonito',
        '2022-01-11',
        'Blanco',
        4,
        'https://i.ibb.co/zhVz38K/IMG-20221029-135858671.jpg',
        1,
        true,
        false,
        NULL,
        2
    ),
    (
        '2024-01-15 22:50:06',
        'Mi vaca',
        '2017-01-01',
        'rosada',
        4,
        'https://xfsjxwksnfwyzzstutvv.supabase.co/storage/v1/object/public/bovines_photos/2024-01-15T22:49:56.662283.jpg',
        1,
        true,
        false,
        NULL,
        2
    );

''';
