# Getting Started with Managed Snowflake MCP Server

This guide outlines the process for getting started with Managed Snowflake MCP Server.

## Overview

The Snowflake MCP Server allows AI agents to securely retrieve data from Snowflake accounts without needing to deploy separate infrastructure. MCP clients discover and invoke tools, and retrieve data required for the application. The Snowflake MCP Server includes Cortex Analyst and Cortex Search as tools on the standards-based interface. It is now available with Model Context Protocol (MCP) so that AI Agents can discover and invoke tools (Cortex Analyst, Cortex Search) via a unified and standard based interface.

**Top 3 Benefits**

- **Governed By Design:** Enforce the same trusted governance policies, from role-based access to masking, for the MCP server as you do for your data.
- **Reduced Integration:** With the MCP Server, integration happens once. Any compatible agent can then connect without new development, accelerating adoption and reducing maintenance costs.
- **Extensible Framework:** Provide agents with out-of-the-box secure access to structured and unstructured data. You can refine the tools to improve how agents interact with your data.

**Why It Matters**

MCP Server on Snowflake simplifies the application architecture and eliminates the need for custom integrations. Enterprises can expedite delivery of generative AI applications with richer insights on a standards based architecture and a robust governance model with the Snowflake AI data cloud.

![MCP](./Getting%20Started%20with%20Managed%20Snowflake%20MCP%20Server_files/mcp.png)

### Prerequisites

- Access to a Snowflake account with ACCOUNTADMIN role. If you do not have access to an account, create a [free Snowflake trial account](https://signup.snowflake.com/?utm_source=snowflake-devrel&utm_medium=developer-guides&utm_cta=developer-guides).
- Access to [Cursor](https://cursor.com/) or equivalent MCP client (we will not test this today)

### What You Will Learn

- How to create building blocks for Snowflake MCP Server that can intelligently respond to questions by reasoning over data
- How to configure Cursor to interact with Snowflake MCP Server (again, not testing today)

### What You Will Build

A Snowflake MCP Server that intelligently responds to questions by reasoning over data from within Cursor.

---

## Setup

### Create Objects

 In Snowsight, [create a SQL Worksheet](https://docs.snowflake.com/en/user-guide/ui-snowsight-worksheets-gs?_fsi=THrZMtDg,%20THrZMtDg&_fsi=THrZMtDg,%20THrZMtDg#create-worksheets-from-a-sql-file) and open [setup.sql](https://github.com/Snowflake-Labs/sfguide-getting-started-with-snowflake-mcp-server/blob/main/setup.sql) to execute all statements in order from top to bottom.

### Programmatic Access Token

Create a [Programmatic Access Token (PAT)](https://docs.snowflake.com/en/user-guide/programmatic-access-tokens) **for your role** and make a note/local copy of it. (You will need to paste it later.)

- In Snowsight, go to Governance & security -> User & roles, click on user [USER], click [Generate new token]
- Name: User_pat, Expires in 15 days and set role to [SNOWFLAKE_INTELLIGENCE_ADMIN]

> **NOTE:** PAT is being used for this lab but OAuth is a more typical authentication mechanism per the [documentation](https://docs.snowflake.com/en/user-guide/snowflake-cortex/cortex-agents-mcp).

### Tools

We will use the Cortex Search and Analyst tools created in the previous exercise.

---
## Snowflake MCP Server

> **PREREQUISITE:** Successful completion of steps outlined under **Setup**.

#### Create Snowflake MCP Server

To create the Snowflake MCP server, go to the Workspaces and run the following.

```sql
create or replace mcp server dash_mcp_server from specification
$$
tools:
  - name: "Finance & Risk Assessment Semantic View"
    identifier: "DASH_MCP_DB.RETAIL.FINANCIAL_SERVICES_ANALYTICS"
    type: "CORTEX_ANALYST_MESSAGE"
    description: "Comprehensive semantic model for financial services analytics, providing unified business definitions and relationships across customer data, transactions, marketing campaigns, support interactions, and risk assessments."
    title: "Financial And Risk Assessment"
  - name: "Support Tickets Cortex Search"
    identifier: "DASH_DB_SI.RETAIL.SUPPORT_TICKETS"
    type: "CORTEX_SEARCH_SERVICE_QUERY"
    description: "A tool that performs keyword and vector search over unstructured support tickets data."
    title: "Support Tickets Cortex Search"
  - name: "SQL Execution Tool"
    type: "SYSTEM_EXECUTE_SQL"
    description: "A tool to execute SQL queries against the connected Snowflake database."
    title: "SQL Execution Tool"
    config:
      type: "procedure"
      warehouse: "DASH_WH_S"
      input_schema:
        type: "object"
        properties:
          body:
            description: "Use HTML-Syntax for this. If the content you get is in markdown, translate it to HTML. If body is not provided, summarize the last question and use that as content for the email."
            type: "string"
          recipient_email:
            description: "If the email is not provided, send it to the current user's email address."
            type: "string"
          subject:
            description: "If subject is not provided, use Snowflake Intelligence."
            type: "string"
$$;
```

We need to enable a Network policy to allow testing of the environment.  Put the below into a Workspace and run.  It should show the MCP server is running.

```sql
USE ROLE ACCOUNTADMIN;
-- Create a new policy that allows all traffic
CREATE OR REPLACE NETWORK POLICY allow_all_policy
  ALLOWED_IP_LIST = ('0.0.0.0/0')
  COMMENT = 'Policy to allow all public IPv4 traffic';

ALTER ACCOUNT SET NETWORK_POLICY = allow_all_policy;

ALTER ACCOUNT UNSET NETWORK_POLICY;

SHOW MCP SERVERS; 
```

Before proceeding, test the connection using `curl` to make sure your account URL/MCP server endpoint and PAT are correct.

> **NOTE:** Replace `<YOUR-ORG-YOUR-ACCOUNT>` and `<YOUR-PAT-TOKEN>` with your values.  

```bash
curl -X POST "https://<YOUR-ORG-YOUR-ACCOUNT>.snowflakecomputing.com/api/v2/databases/dash_db_si/schemas/retail/mcp-servers/dash_mcp_server" \
  --header 'Content-Type: application/json' \
  --header 'Accept: application/json' \
  --header "Authorization: Bearer <YOUR-PAT-TOKEN>" \
  --data '{
    "jsonrpc": "2.0",
    "id": 12345,
    "method": "tools/list",
    "params": {}
  }'
```

After running this command, you should see an error due to agent setup (expected) but it will give you an idea of how this will work in your environment. If it was successful you would see a list of configured tools. 

The steps below are how you would test this in Cursor, but note that you should be able to use other clients like CrewAI, Claude by Anthropic, Devin by Cognition, and Agentforce by Salesforce.

#### Cursor

In Cursor, open or create `mcp.json` located at the root of your project and add the following.

> **NOTE:** Replace `<YOUR-ORG-YOUR-ACCOUNT>` and `<YOUR-PAT-TOKEN>` with your values.  And this will not work in our environment due to Network policies.

```json
{
    "mcpServers": {
      "Snowflake MCP Server": {
        "url": "https://<YOUR-ORG-YOUR-ACCOUNT>.snowflakecomputing.com/api/v2/databases/dash_mcp_db/schemas/retail/mcp-servers/dash_mcp_server",
            "headers": {
              "Authorization": "Bearer <YOUR-PAT-TOKEN>"
            }
      }
    }
}
```

Then, select **Cursor** -> **Settings** -> **Cursor Settings** -> **Tools & MCP** and you should see **Snowflake MCP Server** under **Installed Servers**.

### Q&A in MCP Client

Assuming you're able to see the tools under newly installed **Snowflake MCP Server**, let's chat! Start a new chat in Cursor and set your `mcp.json` as context to ask the following sample questions.

#### Q1. Show me the results for risk profile distribution across customer segments with transaction volumes. Include the number of customers, transaction counts, and average transactions per customer for each segment and risk profile combination.

#### Q2. What is the average customer lifetime value by region for customers with Low risk profile?

#### Q3. What is the risk profile distribution across customer segments and their correlation with transaction volumes?

#### Q4. Can you summarize the overall sentiments based on the support calls?

#### Q5. Which support categories would benefit most from automated responses based on transcript analysis?

### Custom Tools

You can also create functions and procedures that be add as custom tools to execute tasks like sending emails. This can be accomplished using `type: "GENERIC"` in the MCP server config.

Let's try that out that in Cursor. Enter the following prompt...

#### Send me an email with a summary of the analysis to YOUR-EMAIL-ADDRESS.

Provided that you've entered your verified email address, you should receive the email.

![MCP Server Email Prompt](./Getting%20Started%20with%20Managed%20Snowflake%20MCP%20Server_files/snowflake-mcp-server-email-prompt.png)

![MCP Server Email](./Getting%20Started%20with%20Managed%20Snowflake%20MCP%20Server_files/snowflake-mcp-server-email.png)

### Optional -- Agent Calling

To see how you can call agent(s) that you have access to, follow these steps.

- [Create an agent for Snowflake Documentation](https://www.snowflake.com/en/developers/guides/getting-started-with-snowflake-intelligence-and-cke/).

> **NOTE:** You may also use an existing agent that you have access to.

- Recreate the Snowflake MCP Server as follows. Notice new `type: "CORTEX_AGENT_RUN"` added at the end.

```sql
create or replace mcp server dash_mcp_server from specification
$$
tools:
  - name: "Finance & Risk Assessment Semantic View"
    identifier: "DASH_DB_SI.RETAIL.FINANCIAL_SERVICES_ANALYTICS"
    type: "CORTEX_ANALYST_MESSAGE"
    description: "Comprehensive semantic model for financial services analytics, providing unified business definitions and relationships across customer data, transactions, marketing campaigns, support interactions, and risk assessments."
    title: "Financial And Risk Assessment"
  - name: "Support Tickets Cortex Search"
    identifier: "DASH_DB_SI.RETAIL.SUPPORT_TICKETS"
    type: "CORTEX_SEARCH_SERVICE_QUERY"
    description: "A tool that performs keyword and vector search over unstructured support tickets data."
    title: "Support Tickets Cortex Search"
  - name: "SQL Execution Tool"
    type: "SYSTEM_EXECUTE_SQL"
    description: "A tool to execute SQL queries against the connected Snowflake database."
    title: "SQL Execution Tool"
    config:
      type: "procedure"
      warehouse: "DASH_WH_S"
      input_schema:
        type: "object"
        properties:
          body:
            description: "Use HTML-Syntax for this. If the content you get is in markdown, translate it to HTML. If body is not provided, summarize the last question and use that as content for the email."
            type: "string"
          recipient_email:
            description: "If the email is not provided, send it to the current user's email address."
            type: "string"
          subject:
            description: "If subject is not provided, use Snowflake Intelligence."
            type: "string"
  - name: "Snowflake Documentation Agent"
    identifier: "SNOWFLAKE_INTELLIGENCE.AGENTS.SNOWFLAKE_DOCUMENTATION"
    type: "CORTEX_AGENT_RUN"
    description: "An agent that performs keyword and vector search over Snowflake Documentation."
    title: "Snowflake Documentation"
$$;
```

- Ask questions that will be routed to `Snowflake_Documentation_Agent`

#### Q1. How do I create an agent?

#### Q2. What are virtual warehouses in Snowflake, and how do I properly size them?

---

## Conclusion And Resources

Congratulations! You've successfully understood the steps to create a Snowflake MCP Server that intelligently responds to questions by reasoning over data from within Cursor.

### What You Learned

- How to create building blocks for Snowflake MCP Server that can intelligently respond to questions by reasoning over data
- How to configure Cursor to interact with Snowflake MCP Server

### Related Resources

- [GitHub Repo](https://github.com/Snowflake-Labs/sfguide-getting-started-with-snowflake-mcp-server)
- [Snowflake-managed MCP server Docs](https://docs.snowflake.com/en/user-guide/snowflake-cortex/cortex-agents-mcp)

---

*Updated January 20, 2026*

*This content is provided as is, and is not maintained on an ongoing basis. It may be out of date with current Snowflake instances.*
