#!/bin/bash
# Colores para los mensajes
GREEN='\033[0;32m'
RED='\033[0;31m'
LGREEN='\033[1;92m'
CYAN='\033[36m'
YELLOW='\033[33m'
BLUE='\033[34m'
MAGENTA='\033[35m'
NC='\033[0m' # Sin color
echo "                                                   "
echo -e "${CYAN}/#######  /###### /#######  /######## /##   /##    "
echo "| ##__  ##|_  ##_/| ##__  ##| ##_____/| ##  / ##   "
echo "| ##  \ ##  | ##  | ##  \ ##| ##      |  ##/ ##/   "
echo "| #######/  | ##  | #######/| #####    \  ###/     "
echo "| ##____/   | ##  | ##____/ | ##__/     >##  ##    "
echo "| ##        | ##  | ##      | ##       /##/  ##    "
echo "| ##       /######| ##      | ########| ##  / ##   "
echo "|__/      |______/|__/      |________/|__/  |__/   "
echo -e "                                                   ${NC}"

echo -e "${CYAN}================================================"
echo -e "                                                   ${NC}"

# Verificar si se proporcionan 4 argumentos
if [ "$#" -ne 4 ]; then
    echo "Uso: $0 archivo1 comando1 comando2 archivo2"
    exit 1
fi

# Almacenar los argumentos en variables
archivo1="$1"
comando1="$2"
comando2="$3"
archivo2="$4"

# Ejecutar el equivalente de línea de comandos original y almacenar la salida en otro archivo
eval "<$archivo1 "$comando1" | "$comando2" > outfile_tester"
ret_original=$?
echo -e "${BLUE}Contenido de outfile_tester:${NC}"
if [ ! -s outfile_tester ]; then
    echo -e "${YELLOW}outfile_tester está vacío${NC}"
else
    cat outfile_tester
fi

# Ejecutar tu programa pipex y almacenar la salida en un archivo
./pipex "$archivo1" "$comando1" "$comando2" "$archivo2"
ret_pipex=$?

# Mostrar los contenidos de los archivos de salida generados
echo -e "${BLUE}Contenido de $archivo2:${NC}"
if [ ! -s "$archivo2" ]; then
    echo -e "${YELLOW}$archivo2 está vacío${NC}"
else
    cat "$archivo2"
fi

echo -e "                                                   ${NC}"
echo -e "${CYAN}------------------------------------------------${NC}"
echo -e "                                                   ${NC}"

# Comparar los archivos outfile_tester y archivo2
echo "Comparación outfile_tester y $archivo2:"
if diff outfile_tester "$archivo2" > /dev/null; then
    echo -e "${GREEN}Archivos OK${NC}"
else
    echo -e "${RED}Archivos KO${NC}"
fi

# Comparar los valores de retorno
echo -e "Comparación entre valores de retorno:"
if [ $ret_original -eq $ret_pipex ]; then
    echo -e "${GREEN}Valor de retorno OK${NC} ($ret_original)"
else
    echo -e "${RED}Valor de retorno KO${NC} ($ret_original vs $ret_pipex)"
fi
echo -e "                                                   ${NC}"
echo -e "${CYAN}================================================${NC}"
