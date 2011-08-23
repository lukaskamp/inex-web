CREATE OR REPLACE FUNCTION existVolunteer(lastName varchar, firstName varchar, birthNumber varchar) RETURNS Boolean AS $$
DECLARE
  cnt integer;
BEGIN
  select count(1) into cnt
  from member 
  where upper(member.me_lastname) = upper(lastName) and
        upper(member.me_firstname) = upper(firstName) and 
        upper(member.me_birthnumber) = upper(birthNumber);

  if cnt = 1 
    then return TRUE;
    elsif cnt = 0 
      then return FALSE;
    else return NULL;
  end if;
END;
$$ LANGUAGE plpgsql;

comment on function existVolunteer(lastName varchar, firstName varchar, birthNumber varchar) is
  'Funkce vrati TRUE, pokud existuje prave 1 osoba s danym prijmenim, jmenem a rodnym cislem. Pokud takovych osob existuje vice, vrati NULL. Jinak vrati FALSE.';