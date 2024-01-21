final viewResumeAllMoney = '''
    SELECT count(*) count, coalesce(sum(bovines_output.sold_amount),0) as sum, 'SALIDA' as type
        from bovines_output
        where bovines_output.sold_amount is not null
    UNION ALL
    SELECT count(bovines.adquisition_amount) count, coalesce(sum(bovines.adquisition_amount),0) as sum, 'ACTUAL' as type
        from bovines
        LEFT JOIN bovines_output ON bovines_output.bovine_id = bovines.id
        where bovines_output.bovine_id is null;
''';
final viewResumeByOwner = '''
 SELECT count(*) count, sum(bovines_output.sold_amount) as sum, owners.name, 'SALIDA' as type
        from bovines_output
              INNER JOIN bovines ON bovines_output.bovine_id = bovines.id
              INNER JOIN owners ON bovines.owner_id = owners.id
              where bovines_output.sold_amount is not null
        group by bovines.owner_id, owners.name
    UNION ALL
    -- Dinero actual en ganado
    SELECT count(*) count, sum(bovines.adquisition_amount) as sum, owners.name, 'ACTUAL' as type
        from bovines
              INNER JOIN owners ON bovines.owner_id = owners.id
              LEFT JOIN bovines_output ON bovines_output.bovine_id = bovines.id
              where bovines_output.id is null and bovines.adquisition_amount is not null
    group by bovines.owner_id, owners.name;
''';
final queryAllBovines = '''
select
  bovines.id,
  bovines.created_at,
  bovines.name,
  bovines.date_birth,
  bovines.color,
  bovines.owner_id,
  bovines.photo,
  bovines.mother_id,
  bovines.is_male,
  bovines.for_increase,
  bovines.adquisition_amount,
  bovines.provenance_id,
  bovines_output.bovine_id
from
  bovines
  left join bovines_output on bovines_output.bovine_id = bovines.id
where
  bovines_output.id is null ORDER BY bovines.id DESC;
''';
final _ = '''
    -- Total salidas
    CREATE view resume_money_all_view as
    SELECT count(*) count, sum(bovines_output.sold_amount) as sum, 'SALIDA' as type
        from bovines_output
        where bovines_output.sold_amount is not null
    UNION ALL
    -- Total existencias
    SELECT count(*) count, sum(bovines.adquisition_amount) as sum, 'ACTUAL' as type
        from bovines
        LEFT JOIN bovines_output ON bovines_output.bovine_id = bovines.id
        where bovines.adquisition_amount is not null;
    -- Salidas de dinero
    CREATE view resume_money_by_owner_view as
    SELECT count(*) count, sum(bovines_output.sold_amount) as sum, owners.name, 'SALIDA' as type
        from bovines_output
              INNER JOIN bovines ON bovines_output.bovine_id = bovines.id
              INNER JOIN owners ON bovines.owner_id = owners.id
              where bovines_output.sold_amount is not null
        group by bovines.owner_id, owners.name
    UNION ALL
    -- Dinero actual en ganado
    SELECT count(*) count, sum(bovines.adquisition_amount) as sum, owners.name, 'ACTUAL' as type
        from bovines
              INNER JOIN owners ON bovines.owner_id = owners.id
              LEFT JOIN bovines_output ON bovines_output.bovine_id = bovines.id
              where bovines_output.id is null and bovines.adquisition_amount is not null
    group by bovines.owner_id, owners.name;
''';
