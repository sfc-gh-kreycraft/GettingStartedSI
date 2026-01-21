-- Content for creating the MCP Server

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

USE ROLE ACCOUNTADMIN;
-- Create a new policy that allows all traffic
CREATE OR REPLACE NETWORK POLICY allow_all_policy
  ALLOWED_IP_LIST = ('0.0.0.0/0')
  COMMENT = 'Policy to allow all public IPv4 traffic';

ALTER ACCOUNT SET NETWORK_POLICY = allow_all_policy;

ALTER ACCOUNT UNSET NETWORK_POLICY;

SHOW MCP SERVERS; 

GRANT USAGE ON MCP SERVER DASH_DB_SI.RETAIL.DASH_MCP_SERVER TO ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;