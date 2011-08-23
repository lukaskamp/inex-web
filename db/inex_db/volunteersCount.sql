CREATE OR REPLACE FUNCTION volunteersCount(lastName varchar, firstName varchar, birthNumber varchar) RETURNS Integer AS $$
DECLARE
  cnt integer;
BEGIN
  select count(1) into cnt
  from member 
  where upper(member.me_lastname) = upper(lastName) and
        upper(member.me_firstname) = upper(firstName) and
        upper(member.me_birthnumber) = upper(birthNumber);

  return cnt;
END;
$$ LANGUAGE plpgsql;

comment on function volunteersCount(lastName varchar, firstName varchar, birthNumber varchar) is
  'Funkce vrati pocet nalezenych osob s danym prijmenim, jmenem a rodnym cislem.';