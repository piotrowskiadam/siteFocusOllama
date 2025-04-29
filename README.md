# SiteFocus Tool 🎯

Narzędzie do analizy spójności tematycznej stron internetowych wykorzystujące embeddingi tekstu.

## 🌟 Funkcje

- Analiza spójności tematycznej stron internetowych
- Wsparcie dla wielu dostawców embeddingów (Ollama, OpenAI, Jina)
- Automatyczne crawlowanie stron z sitemap
- Inteligentne czyszczenie treści (usuwanie menu, stopek, reklam)
- Wizualizacja wyników
- Cache dla crawlowanych stron i embeddingów

## 📋 Wymagania

- Python 3.8+
- Ollama (opcjonalnie dla lokalnych embeddingów)
- Klucz API OpenAI (opcjonalnie)
- Klucz API Jina (opcjonalnie)

## 🚀 Instalacja

1. Sklonuj repozytorium:
```bash
git clone https://github.com/username/sitefocus.git
cd sitefocus
```

:start_line:28
-------

2. Zainstaluj wymagane pakiety:
```bash
pip install -r requirements.txt
```

3. (Opcjonalnie) Zainstaluj i uruchom Ollamę:
- [Instrukcje instalacji Ollamy](https://ollama.ai/download)

## 📦 Tworzenie Instalatorów

Aby stworzyć instalatory dla różnych platform, uruchom skrypt budowlany:
```bash
./build.sh
```

Skrypt automatycznie wykryje system operacyjny i stworzy odpowiednie pakiety:
- **Windows**: portable .exe zipped as `sitefocus-1.0.0-windows.zip` (generated in project root)
- **Windows**: .exe (portable)
- **Linux**: .deb i .rpm
Uwaga:
  - Windows: uruchom `./build.sh` na Windows, aby wygenerować `dist/app.exe`.
  - Linux: pliki `.deb` i `.rpm` pojawią się w katalogu głównym projektu.
  - macOS: uruchom `./build.sh` na macOS, aby wygenerować `SiteFocus.dmg`.
- **macOS**: .dmg

Upewnij się, że masz zainstalowane wymagane narzędzia (np. `fpm` dla Linuxa).

## 🎮 Użycie
1. Uruchom aplikację:
```bash
streamlit run app.py
```

2. Wybierz dostawcę embeddingów (Ollama/OpenAI/Jina)
3. Wprowadź URL referencyjny (opcjonalnie)
4. Wprowadź listę domen do analizy
5. Kliknij START

## 🐳 Uruchamianie z Dockerem

Aby zbudować i uruchomić aplikację za pomocą Dockera, upewnij się, że masz zainstalowanego Dockera oraz Docker Compose. Następnie uruchom następujące polecenie w głównym katalogu projektu:

```bash
docker-compose up --build
```

Spowoduje to zbudowanie obrazu Docker (jeśli nie istnieje) i uruchomienie kontenera. Aplikacja będzie dostępna pod adresem `http://localhost:8501`.

## 📊 Metryki

- **Site Focus Score** - Miara spójności tematycznej (0-100%)
  - <30% - Niska spójność
  - 30-60% - Średnia spójność
  - >60% - Wysoka spójność

## 🔧 Konfiguracja

- Ollama: Domyślnie `http://localhost:11434/`
- OpenAI: Wymaga klucza API
- Jina: Wymaga klucza API

## 📝 Licencja

MIT License

## 👥 Autorzy

- [Roman Rozenberger](https://rozenberger.com)