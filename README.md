# TasteTrack: Gestió Integral de Base de Dades 🍽️

### 📝 Descripció
Aquest projecte consisteix en el disseny i implementació completa d'una base de dades relacional per a la gestió d'un restaurant. El sistema no només emmagatzema dades, sinó que gestiona tot el cicle de vida de la informació: des de la càrrega de dades brutes fins a l'auditoria i les còpies de seguretat automàtiques.

### 🎯 Context
Pràctica final per a l'assignatura de **Gestió de Base de Dades (GBD)** realitzada a La Salle Gràcia. El repte principal va ser garantir la integritat de les dades mitjançant processos d'ETL (Extract, Transform, Load) dins de la pròpia BD.

### 🛠️ Tecnologies i Funcionalitats
*   **Motor:** MySQL / MariaDB.
*   **Disseny Relacional:** Implementació de taules amb claus primàries (PK) i foranes (FK) per a la consistència de dades (taules: `comandes`, `md_plat`, `auditoria`).
*   **Programació SQL:**
    *   **Procedures:** `carregar_comandes_net` per a la neteja i càrrega de dades, i `sincronitzar_cataleg`.
    *   **Triggers:** Automatització d'auditoria (`AFTER UPDATE`, `AFTER DELETE`) per rastrejar canvis de preus o eliminació de plats.
    *   **Automatització:** Procediment `fer_backup` per a la generació de còpies de seguretat automàtiques de les taules crítiques.
*   **Seguretat:** Gestió d'usuaris i assignació de permisos segons el rol.

### 🚀 Com executar-lo
1. Importa el fitxer SQL principal al teu gestor de bases de dades (ex: MySQL Workbench).
2. Executa el procedure de càrrega: `CALL carregar_comandes_net('comandes.csv');`.
3. Verifica el funcionament dels triggers realitzant un canvi a la taula `md_plat` i consultant la taula `auditoria_plats`.
