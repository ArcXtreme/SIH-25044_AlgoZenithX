Here is the clean Markdown code. You can copy the contents of the code block below and paste it directly into your `README.md` file in VS Code.

````markdown
## 🔧 Installation

### Prerequisites
- Python 3.9+
- pip and venv
- Git

### Setup

1. **Clone the repository**
   ```bash
   git clone [https://github.com/yourusername/SIH-25044_AlgoZenithX.git](https://github.com/yourusername/SIH-25044_AlgoZenithX.git)
   cd SIH-25044_AlgoZenithX
````

2.  **Create virtual environment**

    On Windows:

    ```bash
    python -m venv sihenv
    sihenv\Scripts\activate
    ```

    On Mac/Linux:

    ```bash
    python3 -m venv sihenv
    source sihenv/bin/activate
    ```

3.  **Install dependencies**

    ```bash
    pip install -r requirements.txt
    ```

4.  **Run the server**

    ```bash
    uvicorn backend.app.main:app --reload
    ```

5.  **Access API documentation**

      - Swagger UI: https://www.google.com/search?q=http://127.0.0.1:8000/docs
      - ReDoc: http://127.0.0.1:8000/redoc

<!-- end list -->
