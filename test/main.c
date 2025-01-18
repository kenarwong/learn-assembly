#include <stdio.h>
#include <string.h>

int main() {
  char input[256];
  
  printf("Please enter a sentence: ");
  scanf("%255[^\n]", input);
  getchar(); // Consume the newline character left by scanf

  int length = strlen(input);
  printf("The sentence has %d characters.\n", length);
  
  FILE *file = fopen("output.txt", "w");
  if (file == NULL) {
    perror("Error opening file");
    return 1;
  }

  fwrite(input, sizeof(char), strlen(input), file);
  fclose(file);

  file = fopen("output.txt", "r"); // Reopen the file for reading
  if (file == NULL) {
    perror("Error opening file");
    return 1;
  }

  char input2[256];
  size_t bytesRead = fread(input2, sizeof(char), sizeof(input2) - 1, file);
  if (bytesRead == 0 && ferror(file)) {
    perror("Error reading file");
    fclose(file);
    return 1;
  }

  input2[bytesRead] = '\0'; // Null-terminate the string

  printf("The content read from the file is: %s\n", input2);

  fclose(file);

  file = fopen("output.txt", "r");
  if (file == NULL) {
    perror("Error opening file");
    return 1;
  }

  char buffer[256];
  printf("Reading the file using fgets until EOF:\n");
  while (fgets(buffer, sizeof(buffer), file) != NULL) {
    printf("%s", buffer);
  }

  if (ferror(file)) {
    perror("Error reading file with fgets");
    fclose(file);
    return 1;
  }

  fclose(file);

  return 0;
}