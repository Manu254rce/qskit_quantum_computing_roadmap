#!/bin/bash
# Run this script to check for conda and 
# set up Qiskit QC environment

# Terminal Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
# No Color
NC='\033[0m'

# Function to detect OS
detect_os() {
    case "$(uname -s)" in
        Linux*|Darwin*)
            echo "unix"
            ;;
        CYGWIN*|MINGW*|MSYS*)
            echo "windows"
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

# Environment name and YAML file path
ENV_NAME="QuantumComputing"
YAML_FILE="quantum_environment.yml"

# Check if we're in PowerShell on Windows
if [ "$(detect_os)" = "windows" ] || [ -n "$WINDIR" ] || [ -n "$windir" ]; then
    echo -e "${BLUE}Windows environment detected. Running PowerShell commands...${NC}"
    
    # Check if conda is installed
    if ! powershell.exe -Command "& {(Get-Command conda -ErrorAction SilentlyContinue) -ne \$null}" ; then
        echo -e "${RED}Conda is not installed or not in PATH. Please install Miniconda or Anaconda.${NC}"
        echo -e "${YELLOW}Press any key to exit...${NC}"
        read -n 1 -s
        exit 1
    fi
    
    echo -e "${GREEN}Conda is installed.${NC}"
    
    # Check if the YAML file exists
    if [ ! -f "$YAML_FILE" ]; then
        echo -e "${RED}YAML file '$YAML_FILE' not found in the current directory.${NC}"
        echo -e "${YELLOW}Press any key to exit...${NC}"
        read -n 1 -s
        exit 1
    fi
    
    # Check if the environment already exists
    ENV_EXISTS=$(powershell.exe -Command "& {conda env list | Select-String -Pattern \"^$ENV_NAME \"}")
    
    if [ -z "$ENV_EXISTS" ]; then
        echo -e "${BLUE}Creating environment from $YAML_FILE...${NC}"
        powershell.exe -Command "& {conda env create -f \"$YAML_FILE\"}"
    else
        echo -e "${BLUE}Environment '$ENV_NAME' already exists. Updating from $YAML_FILE...${NC}"
        powershell.exe -Command "& {conda env update -f \"$YAML_FILE\" --prune}"
    fi
    
    # Activate the environment
    echo -e "${GREEN}Setup complete!${NC}"
    echo -e "${YELLOW}Please run the following command to activate the environment:${NC}"
    echo -e "${GREEN}conda activate $ENV_NAME${NC}"
    
else
    # Unix-like OS (Linux, macOS)
    echo -e "${BLUE}Unix-like environment detected. Running bash commands...${NC}"
    
    # Check if conda is installed
    if ! command -v conda &> /dev/null; then
        echo -e "${RED}Conda is not installed or not in PATH. Please install Miniconda or Anaconda.${NC}"
        echo -e "${YELLOW}Press any key to exit...${NC}"
        read -n 1 -s
        exit 1
    fi
    
    echo -e "${GREEN}Conda is installed.${NC}"
    
    # Check if the YAML file exists
    if [ ! -f "$YAML_FILE" ]; then
        echo -e "${RED}YAML file '$YAML_FILE' not found in the current directory.${NC}"
        echo -e "${YELLOW}Press any key to exit...${NC}"
        read -n 1 -s
        exit 1
    fi
    
    # Check if the environment already exists
    if conda env list | grep -q "^$ENV_NAME "; then
        echo -e "${BLUE}Environment '$ENV_NAME' already exists. Updating from $YAML_FILE...${NC}"
        conda env update -f "$YAML_FILE" --prune
    else
        echo -e "${BLUE}Creating environment from $YAML_FILE...${NC}"
        conda env create -f "$YAML_FILE"
    fi
    
    # Activate the environment
    echo -e "${GREEN}Setup complete!${NC}"
    echo -e "${YELLOW}Please run the following command to activate the environment:${NC}"
    echo -e "${GREEN}conda activate $ENV_NAME${NC}"
fi