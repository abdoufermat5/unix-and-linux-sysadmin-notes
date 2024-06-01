import subprocess

def run_command(command):
    """Run a system command and return its output."""
    result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    return result.stdout if result.returncode == 0 else result.stderr

def parse_dig_output(output):
    """Parse and format the output of the dig command."""
    lines = output.splitlines()
    formatted_output = "DNS Resolution Information:\n"
    
    for line in lines:
        if line.startswith(";; QUESTION SECTION:"):
            formatted_output += "\nQuestion Section:\n"
        elif line.startswith(";; ANSWER SECTION:"):
            formatted_output += "\nAnswer Section:\n"
        elif line.startswith(";; AUTHORITY SECTION:"):
            formatted_output += "\nAuthority Section:\n"
        elif line.startswith(";; ADDITIONAL SECTION:"):
            formatted_output += "\nAdditional Section:\n"
        
        if line.startswith(";"):
            continue

        formatted_output += line + "\n"
    
    return formatted_output

def parse_traceroute_output(output):
    """Parse and format the output of the traceroute command."""
    lines = output.splitlines()
    formatted_output = "Traceroute Information:\n"

    for line in lines:
        formatted_output += line + "\n"

    return formatted_output

def main(domain):
    """Main function to execute dig and traceroute commands and display the results."""
    print(f"Resolving DNS and tracing route for: {domain}\n")

    # Run dig command
    dig_command = ["dig", domain]
    dig_output = run_command(dig_command)
    formatted_dig_output = parse_dig_output(dig_output)
    print(formatted_dig_output)
    
    # Run traceroute command
    traceroute_command = ["traceroute", domain]
    traceroute_output = run_command(traceroute_command)
    formatted_traceroute_output = parse_traceroute_output(traceroute_output)
    print(formatted_traceroute_output)

if __name__ == "__main__":
    domain = input("Enter the domain you want to resolve: ")
    main(domain)
