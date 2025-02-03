with open("top1000words.txt", "r") as file:
    words = file.read().splitlines()  # Read words line by line

comma_separated = ",".join(words)  # Join with commas

with open("output.txt", "w") as file:
    file.write(comma_separated)  # Save to a new file

print(comma_separated)  # Print to check
