from locust import HttpUser, TaskSet, task

class MyTaskSet(TaskSet):
    @task
    def make_request(self):
        paths = ['', 'k8s']  # Add more paths if needed
        for path in paths:
            url = f"{self.parent.endpoint}/{path}"
            response = self.client.get(url)
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

class MyUser(HttpUser):
    tasks = [MyTaskSet]
    endpoint = "https://meme.boredotter.dev"  # Replace with the new endpoint
    num_requests = 999  # Adjust the number of requests as needed
    output_file = "results.txt"  # Specify the output file name

    def on_start(self):
        print(f"Starting load test for {self.num_requests} requests to {self.endpoint}")

    def on_stop(self):
        print("Load test complete. Results appended to", self.output_file)

    @staticmethod
    def save_results(num_requests, successful_requests, total_time, occurrences, output_file):
        with open(output_file, 'a') as file:
            file.write(f"\nTest Results for {num_requests} requests to {MyUser.endpoint}\n")
            file.write(f"Total Requests: {num_requests}\n")
            file.write(f"Successful Requests: {successful_requests}\n")
            file.write(f"Total Time: {total_time} seconds\n")
            file.write(f"Requests per Second: {num_requests / total_time}\n")

            file.write("\nOccurrences of values in /k8s responses:\n")
            for value, count in occurrences.items():
                file.write(f"{count} occurrences of {value}\n")

    def on_request_success(self, request_type, name, response, **kwargs):
        if 'k8s' in response.request.path:
            json_data = response.json()
            if 'HOSTNAME' in json_data:
                self.environment.runner.stats.get('MyTaskSet').occur(str(json_data['HOSTNAME']))

    def on_start(self):
        super(MyUser, self).on_start()
        self.client.verify = False

    def on_stop(self):
        occurrences = self.environment.runner.stats.get('MyTaskSet').entries
        successful_requests = sum(1 for _, result in occurrences.items() if result == 200 or (isinstance(result, dict) and result.get('HOSTNAME')))
        total_time = self.environment.runner.stats.total_run_time
        self.save_results(self.num_requests, successful_requests, total_time, occurrences, self.output_file)
