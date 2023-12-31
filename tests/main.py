import requests
from concurrent.futures import ThreadPoolExecutor
import time
from collections import Counter

def load_test(endpoint, paths, num_requests, output_file):
    start_time = time.time()

    def make_request(path):
        url = f"{endpoint}/{path}"
        response = requests.get(url)
        print(f"Request for {url} - Status code: {response.status_code}")

        if path == 'k8s' and response.status_code == 200:
            try:
                json_data = response.json()
                return json_data
            except Exception as e:
                print(f"Error parsing JSON response: {e}")
                return None
        elif path != 'k8s':
            return response.status_code
        else:
            return None

    with ThreadPoolExecutor() as executor:
        results = list(executor.map(make_request, paths * (num_requests // len(paths))))

    end_time = time.time()
    total_time = end_time - start_time

    # Count successful requests based on status codes
    successful_requests = sum(1 for result in results if result == 200 or (isinstance(result, dict) and result.get('HOSTNAME')))

    # Append values to the file
    with open(output_file, 'a') as file:
        file.write(f"\nTest Results for {num_requests} requests to {endpoint}\n")
        file.write(f"Total Requests: {num_requests}\n")
        file.write(f"Successful Requests: {successful_requests}\n")
        file.write(f"Total Time: {total_time} seconds\n")
        file.write(f"Requests per Second: {num_requests / total_time}\n")

        # Count occurrences of specific values in the '/k8s' responses
        k8s_responses = [result for result in results if isinstance(result, dict) and result.get('HOSTNAME')]
        counter = Counter(str(response) for response in k8s_responses)
        
        # Append occurrences to the same file
        file.write("\nOccurrences of values in /k8s responses:\n")
        for value, count in counter.items():
            file.write(f"{count} occurrences of {value}\n")

if __name__ == "__main__":
    endpoint = "https://meme.boredotter.dev"  # Replace with the new endpoint
    paths = ['', 'k8s']  # Add more paths if needed
    num_requests = 100  # Adjust the number of requests as needed
    output_file = "results.txt"  # Specify the output file name

    print(f"Starting load test for {num_requests} requests to {endpoint}")
    load_test(endpoint, paths, num_requests, output_file)
    print("Load test complete. Results appended to", output_file)
