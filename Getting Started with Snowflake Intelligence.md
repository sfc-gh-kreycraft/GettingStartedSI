# Getting Started with Snowflake Intelligence - Brookfield

This guide outlines the process for getting started with Snowflake Intelligence.

## What is Snowflake Intelligence?

Ask complex questions of all your data, analyze and get insights instantly with Snowflake Intelligence as your always-on thought partner.

- **Deep analysis, quick action:** Go beyond the "what" to quickly understand the critical "why," accelerating action with AI agents that use natural language to analyze and reason across all your data, including third-party sources and market intelligence.
- **Verified, trusted answers:** Trace every answer to its source. Codify "golden" questions for verified answers.
- **Enterprise-ready:** Maintain peace of mind knowing that Snowflake Intelligence scales with your enterprise data and application complexity — all within Snowflake's secure perimeter and with the same robust governance policies.

![Snowflake Intelligence](https://www.snowflake.com/content/dam/snowflake-site/developers/guides/getting-started-with-snowflake-intelligence/si.png)

## Use Cases

Snowflake Intelligence streamlines data-driven decision-making across various business use cases:

- **Sales performance analysis:** Sales managers can quickly get answers to complex questions like "What were my top product sales in the West region last quarter, and why did product X outperform product Y?" while analysts can understand critical trends like "Why are support tickets increasing?" by reasoning across diverse data sources.

- **Enhanced research & financial insights:** Enrich internal data with external sources via Cortex Knowledge Extensions, allowing financial analysts to combine portfolio performance with market news, or product managers to analyze customer feedback alongside industry reports for deeper context.

- **Self-service data exploration:** Enable all business users to independently explore data and get immediate answers to complex questions, reducing reliance on data teams and accelerating decisions across the organization.



## What You Will Learn

How to create the building blocks (agents) for Snowflake Intelligence and then monitor the usage.

## What You Will Build

An Enterprise Intelligence Agent - Snowflake Intelligence - that can respond to questions by reasoning over both structured and unstructured data.

---

## Setup

### Create database, schema, tables and load data from AWS S3

- Download the "getting started SI setup.sql" or use the link below to the setup.sql.
- In Snowsight, [create a SQL Worksheet](https://docs.snowflake.com/en/user-guide/ui-snowsight-worksheets-gs?_fsi=THrZMtDg,%20THrZMtDg&_fsi=THrZMtDg,%20THrZMtDg#create-worksheets-from-a-sql-file), paste the content from [setup.sql](https://github.com/Snowflake-Labs/sfguide-getting-started-with-snowflake-intelligence/blob/main/setup.sql) (alternatively look at "getting started SI setup.sql"), click on the arrow beside the Run button and choose to **"Run All"** (do not just click the play button).

> **NOTE:** Switch your user role in Snowsight to **SNOWFLAKE_INTELLIGENCE_ADMIN**.

### Cortex Analyst

This tool enables the agent to query structured data in Snowflake by generating SQL. It relies on semantic views, which are mappings between business concepts (e.g., "product name," "sales") and the underlying tables and columns in your Snowflake account. This abstraction helps the LLM understand how to query your data effectively, even if your tables have complex or arbitrary naming conventions.

- In Snowsight, on the left hand navigation menu, select [**AI & ML** >> **Cortex Analyst**](https://app.snowflake.com/_deeplink/#/cortex/analyst?utm_source=snowflake-devrel&utm_medium=developer-guides&utm_campaign=-us-en-all&utm_content=app-getting-started-with-si&utm_cta=developer-guides-deeplink)
- On the top right, click on **Create new** down arrow and select **Upload your YAML file**
- Upload [marketing_campaigns.yaml](https://github.com/Snowflake-Labs/sfguide-getting-started-with-snowflake-intelligence/blob/main/marketing_campaigns.yaml) | Select database, schema, and stage: **DASH_DB_SI.RETAIL** >> **SEMANTIC_MODELS**
- On the top right, click on **Save**

### Cortex Search

This tool allows the agent to search and retrieve information from unstructured text data, such as customer support tickets, Slack conversations, or contracts. It leverages Cortex Search to index and query these text "chunks," enabling the agent to perform [Retrieval Augmented Generation](https://www.snowflake.com/en/fundamentals/rag/) (RAG).

- In Snowsight, on the left hand navigation menu, select [**AI & ML** >> **Cortex Search**](https://app.snowflake.com/_deeplink/#/cortex/search?utm_source=snowflake-devrel&utm_medium=developer-guides&utm_campaign=-us-en-all&utm_content=app-getting-started-with-si&utm_cta=developer-guides-deeplink)
- On the top right, click on **Create**
  - Role and Warehouse: **SNOWFLAKE_INTELLIGENCE_ADMIN** | **DASH_WH_SI**
  - Database and Schema: **DASH_DB_SI.RETAIL**
  - Name: Support_Cases
  - Select data to be indexed: select SUPPORT_CASES table
  - Select a search column: select TRANSCRIPT
  - Select attribute column(s): select TITLE, PRODUCT
  - Select columns to include in the service: Select all
  - Configure your Search Service: Keep default values **except** select **DASH_WH_SI** for "Warehouse for indexing" (Choose COMPUTE_WH if DASH_WH_SI is not available)



### Create Agent

An agent is an intelligent entity within Snowflake Intelligence that acts on behalf of the user. Agents are configured with specific tools and orchestration logic to answer questions and perform tasks on top of your data.

Note that you can create multiple agents for various use cases and/or business teams in your organization.

- In Snowsight, on the left hand navigation menu, select [**AI & ML** >> **Agents**](https://app.snowflake.com/_deeplink/#/agents?utm_source=snowflake-devrel&utm_medium=developer-guides&utm_campaign=-us-en-all&utm_content=app-getting-started-with-si&utm_cta=developer-guides-deeplink)
- On the top right, click on **Create agent**
  - Select **Create this agent for Snowflake Intelligence**
  - Schema: **SNOWFLAKE_INTELLIGENCE.AGENTS**
  - Agent object name: Sales_AI
  - Display name: Sales AI
- Select the newly created **Sales_AI** agent and click on **Edit** on the top right corner and make the following updates.

### Add Instructions

Add the following starter questions under **Example questions**:

- Show me the trend of sales by product category between June and August
- What issues are reported with jackets recently in customer support tickets?
- Why did sales of Fitness Wear grow so much in July?

### Add Tools

Tools are the capabilities an agent can use to accomplish a task. Think of them as the agent's skillset and note that you can add one or more of each of the following tools.

#### Cortex Analyst

- Click on **+ Add**
  - Add: Semantic model file **DASH_DB_SI.RETAIL.SEMANTIC_MODELS** >> **marketing_campaigns.yaml**
  - Name: Sales_And_Marketing_Data
  - Description: *The Sales and Marketing Data model in DASH_DB_SI.RETAIL schema provides a complete view of retail business performance by connecting marketing campaigns, product information, sales data, and social media engagement. The model enables tracking of marketing campaign effectiveness through clicks and impressions, while linking to actual sales performance across different regions. Social media engagement is monitored through influencer activities and mentions, with all data connected through product categories and IDs. The temporal alignment across tables allows for comprehensive analysis of marketing impact on sales performance and social media engagement over time.*
  - Warehouse: **DASH_WH_SI**
  - Query timeout (seconds): 60

#### Cortex Search Services

- Click on **+ Add**
  - Search service: **DASH_DB_SI.RETAIL** >> **Support_Cases**
  - ID column: ID
  - Title column: TITLE
  - Name: Support_Cases

> **NOTE:** If you optionally created AGGREGATED_SUPPORT_CASES Cortex Search service, you may add it here as well.

#### Custom Tools (note this won't work for our lab but any UDF can be a custom tool)

- Click on **+ Add**
  - Resource type: procedure
  - Database & Schema: **DASH_DB_SI.RETAIL**
  - Custom tool identifier: **DASH_DB_SI.RETAIL.SEND_EMAIL()**
  - Name: Send_Email
  - Warehouse: **DASH_WH_SI**
  - Parameter: body
    - Description: *Use HTML-Syntax for this. If the content you get is in markdown, translate it to HTML. If body is not provided, summarize the last question and use that as content for the email.*
  - Parameter: recipient_email
    - Description: *If the email is not provided, send it to the current user's email address.*
  - Parameter: subject
    - Description: *If the subject is not provided, use "Snowflake Intelligence".*

#### Additional Configuration

- Orchestration Instructions: *Whenever you can answer visually with a chart, always choose to generate a chart even if the user didn't specify to.*
- Orchestration Model: Which LLM should be used to determine the logic. Default should be auto.  *Models subject to availability based on region.*
- Access: SNOWFLAKE_INTELLIGENCE_ADMIN

> **NOTE:** On the top right corner, click on **Save** to save the newly updated **Sales_AI** agent.

---

## Snowflake Intelligence

> **PREREQUISITE:** Successful completion of steps outlined under **Setup**.

Open Agents, go to the Snowflake Intelligence tab and make the agent available to Snowflake Intelligence.

Open [Snowflake Intelligence](https://ai.snowflake.com/_deeplink/#/ai?utm_source=snowflake-devrel&utm_medium=developer-guides&utm_campaign=-us-en-all&utm_content=app-getting-started-with-si&utm_cta=developer-guides-deeplink) and make sure you're signed into the right account. If you're not sure, click on your name in the bottom left >> **Sign out** and sign back in. Also note that your role should be set to **SNOWFLAKE_INTELLIGENCE_ADMIN**, the warehouse should be set to **DASH_WH_SI**, and your agent should be set to Sales//AI.

Now, let's ask the following questions.

### Q1. *Show me the trend of sales by product category between June and August.*

![Q1](https://www.snowflake.com/content/dam/snowflake-site/developers/guides/getting-started-with-snowflake-intelligence/qa_1.png)

---

### Q2. *What issues are reported with jackets recently in customer support tickets?*

![Q2](https://www.snowflake.com/content/dam/snowflake-site/developers/guides/getting-started-with-snowflake-intelligence/qa_2.png)

---

### Q3. *Why did sales of Fitness Wear grow so much in July?*

![Q3](https://www.snowflake.com/content/dam/snowflake-site/developers/guides/getting-started-with-snowflake-intelligence/qa_3.png)


---

### Other Questions

Your Agent is configured to handle a variety of complex queries that blend various types of data. Try these examples to further test the Agent:

Here are some other questions you may ask:

- *Which product categories perform best on social media?*
- *What's the relationship between social media mentions and sales?*
- *How do different regions respond to marketing campaigns?*

---

### Monitoring the Agent's Responses

The logic the agent uses, tools chosen to do a task typically need to be monitored to ensure the right approach is being used.  

Go to Agents, click on the Sales AI agent and look at the Monitoring tab.  This has the prompts provided and all the steps used to get to an answer.

---

## Conclusion And Resources

Congratulations! You've successfully built an enterprise intelligence agent - Snowflake Intelligence - that can respond to questions by reasoning over both structured and unstructured data.

### What You Learned

You've learned how to create the fundamental building blocks for Snowflake Intelligence. This agent is now a powerful asset, capable of combining analysis and automated tasks right from a single chat interface.

### Related Resources

- [GitHub Repository](https://github.com/Snowflake-Labs/sfguide-getting-started-with-snowflake-intelligence)
- [Snowflake Intelligence Documentation](https://docs.snowflake.com/user-guide/snowflake-cortex/snowflake-intelligence)

---

*Updated 2026-01-19*

*This content is provided as is, and is not maintained on an ongoing basis. It may be out of date with current Snowflake instances.*

