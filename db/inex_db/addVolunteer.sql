CREATE OR REPLACE FUNCTION addVolunteer(lastName varchar, 
                                        firstName varchar, 
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
                                        birthNumber varchar,
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
  v_sex varchar;
BEGIN
  if existVolunteer(lastName, firstName, birthNumber)
    then raise exception 'Volunteer already exists in database.';
    --return FALSE;
  end if;

  if upper(sex) = 'MALE' 
    then v_sex := '1'; 
    elsif upper(sex) = 'FEMALE' 
      then v_sex := '0'; 
  end if;

  insert into member(me_id, me_firstname, me_lastname, me_email, me_mobile, me_phone, me_address1, me_address2, me_city, me_zip, 
                     me_comments, me_passport, me_male, me_vegetarian, /*me_maritalstatus,*/ 
                     me_bankcode, me_accountnumber, me_specificsymbol,
                     me_birthdate, me_birthnumber, co_id, me_nationality, me_occupation, me_passportexpiry,
                     me_emergencycontact, me_emdayphone, me_emnightphone, me_speakwell, me_speaksome, me_pastexperience
                    )
  values(nextval('member_me_id_seq'), firstName, lastName, email, mobile, phone, address1, address2, city, zip, 
                 comments, passport, v_sex, vegetarian, /*marialStatus,*/ 
                 bankCode, accountNumber, specificSymbol,
                 birthDate, birthNumber, country, nationality, occupation, passportExpiry,
                 emergencyContact, emDayPhone, emNightPhone, speakWell, speakSome, pastExperience
        );

  return TRUE;
END;
$$ LANGUAGE plpgsql;

comment on function addVolunteer(lastName varchar, 
                                        firstName varchar, 
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
                                        birthNumber varchar,
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
  'Funkce prida do tabulky MEMBER noveho dobrovolnika. Predtim zkontroluje, zda jiz neni obsazen (lastName, firstName, birthNumber). Vrati TRUE, pokud uspesne prida dobrovolnika, jinak je vyhozena vyjimka.';