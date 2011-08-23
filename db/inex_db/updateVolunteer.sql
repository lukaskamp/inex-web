-- Funkce neumoznuje zmenit jmeno, prijmeni a rodne cislo.
CREATE OR REPLACE FUNCTION updateVolunteer(lastName varchar,  -- NEUPDATUJE SE
                                        firstName varchar,  -- NEUPDATUJE SE
                                        email varchar,
                                        mobile varchar,
                                        phone varchar,
                                        address1 varchar,  -- 1. radka adresy
                                        address2 varchar,  -- 2. radka adresy
                                        city varchar,
                                        comments varchar,  -- remarks on health
                                        zip varchar,
                                        passport varchar,
                                        sex varchar,  -- pohlavi = 'male' / 'female' (konvertuje se na '1' / '0')
                                        vegetarian boolean,
                                        -- marialStatus, ???
                                        accountNumber varchar,
                                        bankCode varchar,
                                        specificSymbol varchar,
                                        birthDate timestamp,
                                        birthNumber varchar,  -- NEUPDATUJE SE
                                        country varchar,
                                        nationality varchar,
                                        occupation varchar,
                                        passportExpiry timestamp,
                                        emergencyContact varchar,
                                        emDayPhone varchar,
                                        emNightPhone varchar,
                                        speakWell varchar,
                                        speakSome varchar,
                                        pastExperience varchar
) RETURNS Boolean AS $$
DECLARE
  v_cnt integer;
  v_sex varchar;
  v_text varchar;
BEGIN
  v_cnt := volunteersCount(lastName, firstName, birthNumber);
  if v_cnt = 0
    then raise exception 'Volunteer doesn''t exist in database.';
    --return FALSE;
    elsif v_cnt > 1
      then v_text := 'Too many volunteers to update (' || v_cnt || ').';
           raise exception 'Too many volunteers to update.';
  end if;

  if upper(sex) = 'MALE' 
    then v_sex := '1'; 
    elsif upper(sex) = 'FEMALE' 
      then v_sex := '0'; 
  end if;

  update member
  set ( me_email, me_mobile, me_phone, me_address1, me_address2, me_city, me_zip, 
        me_comments, me_passport, me_male, me_vegetarian, /*me_maritalstatus,*/ 
        me_bankcode, me_accountnumber, me_specificsymbol,
        me_birthdate, co_id, me_nationality, me_occupation, me_passportexpiry,
        me_emergencycontact, me_emdayphone, me_emnightphone, me_speakwell, me_speaksome, me_pastexperience
  ) = (
        email, mobile, phone, address1, address2, city, zip, 
        comments, passport, v_sex, vegetarian, /*marialStatus,*/ 
        bankCode, accountNumber, specificSymbol,
        birthDate, country, nationality, occupation, passportExpiry,
        emergencyContact, emDayPhone, emNightPhone, speakWell, speakSome, pastExperience
  )
  where upper(me_lastname) = upper(lastName) and
        upper(me_firstname) = upper(firstName) and
        upper(me_birthnumber) = upper(birthNumber);

  return TRUE;
END;
$$ LANGUAGE plpgsql;

comment on function updateVolunteer(lastName varchar,  -- NEUPDATUJE SE
                                        firstName varchar,  -- NEUPDATUJE SE
                                        email varchar,
                                        mobile varchar,
                                        phone varchar,
                                        address1 varchar,  -- 1. radka adresy
                                        address2 varchar,  -- 2. radka adresy
                                        city varchar,
                                        comments varchar,  -- remarks on health
                                        zip varchar,
                                        passport varchar,
                                        sex varchar,  -- pohlavi = 'male' / 'female' (konvertuje se na '1' / '0')
                                        vegetarian boolean,
                                        -- marialStatus, ???
                                        accountNumber varchar,
                                        bankCode varchar,
                                        specificSymbol varchar,
                                        birthDate timestamp,
                                        birthNumber varchar,  -- NEUPDATUJE SE
                                        country varchar,
                                        nationality varchar,
                                        occupation varchar,
                                        passportExpiry timestamp,
                                        emergencyContact varchar,
                                        emDayPhone varchar,
                                        emNightPhone varchar,
                                        speakWell varchar,
                                        speakSome varchar,
                                        pastExperience varchar) is
 'Funkce aktualizuje zaznam o dobrovolnikovi v tabulce MEMBER. Predtim zkontroluje, zda existuje prave jeden (lastName, firstName, birthNumber). Vrati TRUE, pokud uspesne, jinak je vyhozena vyjimka. Funkce neumoznuje zmenit jmeno, prijmeni a rodne cislo.';