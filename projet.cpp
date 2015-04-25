#include <iostream>
#include <iomanip>
#include <ctime>
#include <string>
#include <exception>
#include <soci.h>
#include <oracle/soci-oracle.h>
#include <boost-tuple.h>
#include <boost-optional.h>

using namespace soci;
using namespace std;

enum eTables {VOL, AFFECT, RESERV, AERO, AVION, APP};

void menuPrincipal(session&);
void menuAdministrateur(session&);
void menuUtilisateur(session&);
void affichTableInfo(session&, string);
void affichTable(session&, eTables);
string genTableNom(eTables);

int main()
{	
	try
	{
		session sql(oracle, "service=XE user=EOB3320 password=BLAN1520");
		menuPrincipal(sql);
	}
	catch(exception const &e)
	{
		cerr << "Error: " << e.what() << '\n';
	}

	return 0;
}

void menuPrincipal(session& sql)
{
	int sel;
	while(true)
	{	
		cout << "*** MENU PRINCIPAL ***" << endl
			 << "(1) Menu Utilisateur." << endl
			 << "(2) Menu Administrateur." << endl
			 << "(3) Quitter." << endl;

		cin >> sel;
		switch(sel)
		{
			case 1:
			{
				menuUtilisateur(sql);
				break;
			}
			case 2:
			{
				menuAdministrateur(sql);
				break;
			}
			case 3:
			{
				return;
			}
			default: 
				break;
		}
	}
}

void menuAdministrateur(session& sql)
{
	int sel;
	while(true)
	{
		cout << "*** MENU ADMINISTRATEUR ***" << endl
			 << "(1) Ajouter/Supprimer/Modifier une affectation." << endl
			 << "(2) Ajouter/Supprimer/Modifier un vol." << endl
			 << "(3) Ajouter/Supprimer/Modifier une avion." << endl
			 << "(4) Ajouter/Supprimer/Modifier une appareil." << endl
			 << "(5) Quitter." << endl;
		
		cin >> sel;
		switch(sel)
		{
			case 1:
			{
				
				break;
			}
			case 2:
			{
				string numVol, codeDep, codeArr, heureMinDep, heureMinArr;
				int jourArr;

				affichTable(sql, VOL);

				cout << "(1) Ajouter." << endl
				 << "(2) Modifier." << endl
				 << "(3) Supprimer." << endl
				 << "(4) Annuler." << endl;

				int sel;
				cin >> sel;
				switch(sel)
				{
					case 1 :
					{
						cout << endl << "Veuillez entrer les valeurs des champs:" << endl;					 
						cout << "numVol: ";	cin >> numVol;					
						cout << "codeDep: "; cin >> codeDep;
						cout << "codeArr:"; cin >> codeArr;
						cout << "heureMinDep: "; cin >> heureMinDep;
						cout << "heureMinArr: "; cin >> heureMinArr;
						cout << "jourArr: "; cin >> jourArr;
						cout << endl;
					
						sql << "INSERT INTO VOL VALUES ('"
							<< numVol << "','" << codeDep << "','" << codeArr << "','"						
							<< heureMinDep << "','" << heureMinArr << "','" << jourArr << "')";
						
						break;				
					}
					case 2 :
					{
						break;				
					}
					case 3 :
					{
						break;				
					}
					default:
						break;
				}			
				break;
			}
			case 3:
			{
				break;
			}
			case 4:
			{
				break;	
			}
			case 5:
			{
				return;
			}
			default: 
				break;
		}
	}
}

void menuUtilisateur(session& sql)
{
	int sel;
	while(true)
	{	
		cout << "*** MENU PRINCIPAL ***" << endl
			 << "(1) Afficher la liste des vols disponibles entre deux villes a une date donnee." << endl
			 << "(2) Ajouter/Supprimer/Modifier une reservation." << endl
			 << "(3) Quitter." << endl;

		cin >> sel;
		switch(sel)
		{
			case 1:
			{				
				break;
			}
			case 2:
			{
				break;
			}
			case 3:
			{
				return;
			}
			default: 
				break;
		}
	}
}

void affichTableInfo(session& sql, string tableNom)
{
	cout << endl;	
	rowset<row> tuples = (sql.prepare << "SELECT COLUMN_NAME FROM COLS WHERE TABLE_NAME = '"+tableNom+"'");
	string colName;
	for(auto it = tuples.begin(); it != tuples.end(); ++it)
	{
		*it >> colName;
		cout << colName << " ";
	}
	cout << endl << endl;
}

void affichTable(session& sql, eTables tableEnum)
{
	string tableNom = genTableNom(tableEnum);

	affichTableInfo(sql, tableNom);
		
	switch(tableEnum)
	{
		case VOL:
		{			
			rowset<row> rs = (sql.prepare << "SELECT * FROM VOL");
			string numVol, codeDep, codeArr, heureMinDep, heureMinArr;
			int jourArr;
			for(rowset<row>::const_iterator it = rs.begin(); it != rs.end(); ++it)
			{				
				row const& ligne = *it;
				numVol = ligne.get<string>(0);
				codeDep = ligne.get<string>(1);
				codeArr = ligne.get<string>(2);
				heureMinDep = ligne.get<string>(3);
				heureMinArr = ligne.get<string>(4);
				jourArr = ligne.get<int>(5);
         		
				cout << numVol << " " << codeDep << " " << codeArr << " "
					 << heureMinDep << " " << heureMinArr << " " 
					 << jourArr << endl << endl;					
			}
			break;
		}
		case AFFECT: 
		{
			break;
		}
		case RESERV:
		{
			break;
		} 
		case AERO: 
		{
			break;
		}
		case AVION: 
		{
			break;
		}
		case APP: 
		{
			break;
		}
		default:
			break;
	}  	
}

string genTableNom(eTables tableEnum)
{
	switch(tableEnum)
	{
		case VOL: return "VOL";
		case AFFECT: return "AFFECTATION";
		case RESERV: return "RESERVATION";
		case AERO: return "AEROPORT";
		case AVION: return "AVION";
		case APP: return "APPAREIL";
		default: return "";	
	}
}
