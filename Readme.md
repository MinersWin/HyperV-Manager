[![Codacy Badge](https://api.codacy.com/project/badge/Grade/60890a1330904eb98e6e9fb7c3c8b943)](https://www.codacy.com/manual/MinersWin/TGF-Tuning-Pack-4.0?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=MinersWin/TGF-Tuning-Pack-4.0&amp;utm_campaign=Badge_Grade)
    <a href="https://tuning-pack.de">
        <img src="https://img.shields.io/circleci/project/github/badges/shields/master" alt="build status"></a>
    <a href="https://tuning-pack.de">
        <img src="https://img.shields.io/coveralls/github/badges/shields"
            alt="coverage"></a>
    <a href="https://tuning-pack.de">
        <img src="https://img.shields.io/lgtm/alerts/g/badges/shields"
            alt="Total alerts"/></a>
    <a href="https://tuning-pack.de">
        <img src="https://img.shields.io/github/commits-since/badges/shields/gh-pages?label=commits%20to%20be%20deployed"
            alt="commits to be deployed"></a>
```
.MOTIVATION
        Ich hab noch nie ein Programm derart in Powershell gefunden, also dachte Ich mir machste es selber.
    .DATEN
        Name: HyperV-Manager.ps1
        Version: B.E.T.A. 1.9.11
        Author: Minerswin
        Creation-Date: 09-04-2019
        Last-Update: 02.07.2019
        Mail: hyperv-manager@minerswin.de
    .CHANGELOG
        B.E.T.A. 1.9.0 - MinersWin - 10.04.2019 - Nun mit GUI + Auswahl des Hosts + Auswahl der VM
        B.E.T.A. 1.9.1 - MinersWin - 11.04.2019 - Erstellung einer TextBox um dauerhaft den Aktuellen Status anzeigen zu lassen + Erstellung eigener VMs (Ohne Funktion)
        B.E.T.A. 1.9.2 - MinersWin - 12.04.2019 - Einbringung einiger Funktionen: Snapshots, ISOS, und Start/Stop
        B.E.T.A. 1.9.3 - MinersWin - 15.04.2019 - Möglichkeit der Erstellung Virtueller Switches, Bearbeiten der VMs, ERstellung von Startskripten, Installation der Verwaltungstools + Rechtevergabe
        B.E.T.A. 1.9.4 - MinersWin - 16.04.2019 - Automatische erkennung der VMs, übersichtlichere Formatierung, Einbindung der Thumbnailfunktion + ISO Wechsel + Feedback Form
        B.E.T.A. 1.9.5 - MinersWin - 17.04.2019 - Erstellung einer Config.txt, Automatisches Erstellen einer temporären log-Datei, Einbau der Funktion, die Log + Computerinfos bei Problemen an den Entwickler zu senden
        B.E.T.A. 1.9.6 - MinersWin - 18.04.2019 - Möglichkeit zur Speicherung der Log Datei, Automatisch überprüfung der Version
        B.E.T.A. 1.9.7 - MinersWin - 29.04.2019 - Möglichkeit der Erstellung von VMs, einfügen einer Feedback Funktion
        B.E.T.A. 1.9.8 - MinersWin - 30.04.2019 - Möglichkeit des An/Ausschaltens von VMs + Möglichkeit zur Festlegung von Prozessorkernen, RAM und ISO Datei bei der Erstellung
        B.E.T.A. 1.9.9 - MinersWin - 20.05.2019 - Möglichkeit zur erstellung von Virtuellen Switches und verbesserung der LOG Datei
        B.E.T.A. 1.9.10 - MinersWin - 21.05.2019 - Fertigstellung der VM Edit Funktion + Autosenden des Feedbacks an den Creator.
        B.E.T.A. 1.9.11 - MinersWin - 02.07.2019 - Entfernen des MailServers + Configupdate
        B.E.T.A. 1.9.12 - MinersWin - 04.07.2019 - Integration von BallonTips, 
        B.E.T.A. 1.9.13 - MinersWin - 10.07.2019 - Möglichkeit zur Änderung des Namens in der Config Datei sowie eintragen eigener Mail Server, Automatische erstellung der Config Datei, Erstellung einer Start.bat, Überarbeitung der ReadMe, Update auf GitHub, Überarbeitung der BaloonTips

    .BEISPIEL
        .\HyperV-Manager.ps1 
    .IN_ZUKUNFT_GEPLANT
      - Automatische Erstellung von Connect-Skripts
      - Automatische Rechtezuweisung für die Einzelen Personen
      - Wenn Template Vorhanden soll das Benutzt werden (spart Installation)
      - Erstellung eines Clients für die Azubis, mit welchem sie VMs beantragen können.
      - Automatische Installation der Verwaltungsdienste auf den Azubi-Computern
      - Möglichkeit RAM,CPU,NETZWERK,FESTPLATTENGRÖßE usw. zu ändern
      - Start-Animation
      - ...

    .LIZENZ
      Es ist Verboten diese Dateien Weiterzuverkaufen, als Eigenwerk auszugeben oder zu Lizenzieren.
      Es ist Erlaubt Teile des Codes bzw. Dateien für eigene Projekte zu übernehmen, diese Projekte dürfen jedoch keinen Kommerziellen Nutzen haben, müssen unter gleichen Bedingungen weitergegeben werden und Minerswin muss als Urheber mitgenannt werden.
      Das Projekt unterliegt der Creative Commons Lizenz 4.0 mit "by", "nc" und "sa" Modulen, d.h. Der Name des Urhebers muss genannt werden, Kommerzielle Nutzung ist Verboten, die Weitergabe muss unter den Selben bedingungen geschehen. 

    .PROBLEMBEHANDLUNG
      - Sollte es zu diesem Fehler kommen, "Die Datei .\HyperV-Manager.ps1 kann nicht geladen werden, da die Ausführung von Skripts auf diesem System deaktiviert ist." lässt sich dieses durch das Ausführn des Folgenden Befehls beheben: "Set-ExecutionPolicy Unrestricted -Scope Process"
      - Sollte es zu diesem Fehler kommen, "Get-ADComputer : Es wurde kein Standardserver gefunden, auf dem die Active Directory-Webdienste ausgeführt werden." Kann es sein, dass sich der Computer in keiner Domäne befindet, oder dass die Active Directory Dienste nicht Installiert bzw. Aktiviert sind.#
      - Sollte es zu diesem Fehler kommen, "Get-VM : Sie besitzen nicht die erforderliche Berechtigung für diese Aufgabe. Wenden Sie sich an den Administrator der Autorisierungsrichtlinie für Computer {Hostname}." Kann es sein, dass entweder die Hyper-V Plattform nicht auf dem ZielServer Installiert ist oder dem Nutzer die Rechte der Remotedesktopverwaltung fehlen.
      - Sollte es zu diesem Fehler kommen, "Get-VM : Von Hyper-V wurde kein virtueller Computer mit dem Namen {Name} gefunden." dann ist entweder der Name der VM falsch eingegeben worden oder eine ungültige VM ausgewählt worden.

    .FAQ
      - Ich habe einen Fehler gefunden, wo kann ich ihn Melden? - Dazu kann man einfach im Reiter Aktion auf Feedback gehen und im Feld das Feedback eingeben. Alternativ einfach eine E-Mail an "HyperV-Manager@MinersWin.de" schreiben.
      - Werden irgenwelche Daten gesammelt? - Die Log-Dateien werden mit dem Beenden des Programms gelöscht, sofern sie nicht über den Button Informationen Senden an den Ersteller Gesendet wurden.
```
