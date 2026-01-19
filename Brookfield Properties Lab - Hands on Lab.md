# Brookfield Properties Lab | Hands on Lab (Step 2)

## Why are we here?

To learn about Snowflake's AI capabilities through a hands-on approach, building a comprehensive AI-powered asset management system that showcases real-world enterprise AI transformation.

## The lab environment

A complete lab environment has been built for you automatically. This includes:

- **Snowflake Account**: sfsehol-brookfield_properties_lab_xwbucd
- **User**: USER
- **Snowflake Virtual Warehouse**: ASSET_MANAGEMENT_AI_WH
- **Snowflake Database**: DATAOPS_EVENT_PROD
- **Schema**: RESEARCH_ANALYTICS

> ⚠️ **Warning: This lab environment will disappear!**
> 
> This event is due to end at 2026-01-25 04:00:00+00:00, at which point access will be restricted, and accounts will be removed.

## Structure of the session

This walkthrough contains everything you need. We will also demonstrate a number of the key steps live.

---

# 🏔️ Snowflake Asset Management AI Transformation Lab

## 🎯 What You'll Learn

In this hands-on lab, you'll experience how to build a comprehensive AI-powered asset management system using Snowflake's integrated AI platform. You'll work with real investment data and research documents to create an intelligent system that demonstrates enterprise AI transformation.

### 🚀 Lab Objectives

By the end of this lab, you'll have built and interacted with a fully functional AI system that can:

✅ **Search through research documents** using natural language queries via Cortex Search  
✅ **Analyze portfolio data** with conversational queries using Cortex Analyst  
✅ **Provide intelligent recommendations** combining both data sources through Snowflake Intelligence  

### 🏗️ Lab Components

Your lab environment includes:

**Pre-configured:**

- 📁 **Research Documents** - 8 sample investment research PDFs already uploaded
- 💾 **Portfolio Data** - Sample holdings data across Technology, Healthcare, ESG, and Real Estate sectors
- 📓 **Snowflake Notebook** - Ready to run for Cortex Search setup


**You'll configure during the lab:**

- 🔍 **Cortex Search Service** - You'll create `INVESTMENT_SEARCH_SVC` for intelligent document search
- 📊 **Cortex Analyst Model** - You'll upload and configure the portfolio analysis semantic model
- 🤖 **Snowflake Intelligence Agent** - You'll build an AI assistant with dual capabilities

## 📋 Lab Environment Setup

### 🔧 Pre-Configured Infrastructure

Your lab environment has been automatically configured with:

**Security & Access:**

- **Role**: `asset_management_ai_role` with Cortex and Streamlit capabilities
- **Warehouse**: `asset_management_ai_wh` (optimized for AI workloads)
- **Permissions**: Full access to AI services and data

**Data Infrastructure:**

- **Database**: `ASSET_MANAGEMENT_AI`
- **Schema**: `RESEARCH_ANALYTICS`
- **Stage**: `RESEARCH_DOCS` with uploaded research documents
- **Table**: `PORTFOLIO_HOLDINGS` with 13 sample portfolio holdings

**AI Services Setup:**

- **Cortex Search**: You'll configure the document search service using the notebook
- **Cortex Analyst**: You'll upload the semantic model for portfolio analysis
- **Snowflake Intelligence**: You'll create an AI agent combining both capabilities

### 📚 Available Research Documents

Your environment includes these pre-loaded research documents:

- NovaTech Insights - Technology Sector Overview.pdf
- NovaTech Insights - Emerging Markets.pdf
- NovaTech Insights - ESG Trends.pdf
- Gaming Industry Trends in 2025.pdf
- FinTech Innovation Investment Opportunities.pdf
- Dissertation on the Utility Sector.pdf
- Stellar Motors Inc. - 10-K Annual Report.pdf
- SNOW_2025.pdf

## 🚀 Lab Activities Flow

Follow these activities in sequence to build your complete AI-powered asset management system:

### Activity 1: Create Cortex Search Service

**Objective**: Set up intelligent document search capabilities

1. Navigate to **Projects → Notebooks** in Snowsight
2. Open the pre-loaded `NOTEBOOK_0_START_HERE` notebook
3. Execute the notebook cells sequentially to:
   - Process the uploaded research documents
   - Create vector embeddings using Snowflake Cortex
   - Deploy the `INVESTMENT_SEARCH_SVC` Cortex Search service

**What you'll learn**: How to transform unstructured documents into searchable knowledge

### Activity 2: Build Snowflake Intelligence Agent

**Objective**: Create an AI assistant that combines both capabilities

1. **Access Snowflake Intelligence**
   - Navigate to AI & ML → Agents in Snowsight
   - Click + Agent to create a new agent

2. **Configure Agent Basic Settings**
   
   Configure your agent with these details:
   - Platform Integration: Check **Create this agent for Snowflake Intelligence**
   - Agent Name: `Research_Assistant`
   - Display Name: `Research Assistant`
   - Click **Create**
   - Click **Edit** and navigate to **Orchestration**
   - Instructions: Copy and paste this instruction set in Orchestration instructions:

```
You are an expert investment research assistant for Global Asset Management. You have access to:

1. A comprehensive research document library via Cortex Search containing reports on technology, healthcare, ESG, and real estate sectors
2. Portfolio data for analyzing current holdings and performance

Your role is to:
- Answer questions about investment research and market analysis
- Provide insights on portfolio holdings and sector performance
- Search through research documents to find relevant information
- Analyze portfolio data to support investment decisions
- Combine document insights with portfolio data for comprehensive analysis

Always provide data-driven responses and cite relevant sources when possible.
```

3. **Add Cortex Analyst Tool**
   - From Tools, click **+ Add Tool**
   - Select **Cortex Analyst**
   - Select semantic model file
   - Select database/schema/stage: Choose `ASSET_MANAGEMENT_AI` → `RESEARCH_ANALYTICS` → `SEMANTIC_MODELS` and select `PORTFOLIO_ANALYSIS.yaml`
   - Add the following details:
     - Name: `Portfolio_analysis`
     - Description: `Analyze portfolio data and generate insights or generate via Cortex`
     - Timeout: 60 seconds
   - Click **Add**

4. **Add Cortex Search Tool**
   - Click **+ Add Tool**
   - Select **Cortex Search**
   - Name: `Document_search`
   - Tool Description: `Search through investment research documents and reports`
   - Choose `ASSET_MANAGEMENT_AI` → `RESEARCH_ANALYTICS` → `INVESTMENT_SEARCH_SVC` service created in Step 4
   - Click **Add**

5. Click **Save**

**Test your agent with these queries:**

**📊 Portfolio Analysis:**
- "What are our current portfolio holdings by sector?"
- "Which holdings have the highest risk levels?"
- "Chart our portfolio holdings by sector and risk"

**🔍 Document Research:**
- "What are the key technology trends mentioned in our research documents?"
- "Find information about ESG investment opportunities"
- "Compare technology sector insights from different reports"

**💡 Strategic Insights:**
- "What ESG trends are likely to impact our portfolio?"
- "Provide a summary of our Technology Sector Overview report and its portfolio impact"

**What you'll learn**: How to combine multiple AI services into a unified intelligent assistant


## 🎯 Lab Story: Asset Management AI Transformation

### 📊 The Business Challenge

You're experiencing how Global Asset Management (GAM) solved a critical challenge where analysts were spending **30-40% of their time** on manual research organization instead of investment analysis:

- Manual classification of research reports and SEC filings
- Keyword-based searches missing critical insights
- Siloed data preventing comprehensive analysis
- Hours to answer urgent research questions during volatile markets

### 🚀 The AI Solution

Through this lab, you're seeing how GAM deployed a comprehensive AI research platform delivering:

- **⚡ 30-second insights** instead of hours of manual research
- **🎯 Semantic understanding** of investment concepts
- **📊 Real-time portfolio analysis** with AI-driven risk assessment
- **🤖 Conversational research assistant** for instant answers

### 💡 Why Snowflake's Approach Works

- **🚀 Integrated AI Stack**: LLMs, embeddings, and vector search natively within the data warehouse
- **⚡ No Infrastructure Management**: Automatic scaling without GPU cluster management
- **💰 Elastic Economics**: Pay only for actual compute usage
- **🔒 Enterprise Security**: SOC 2 compliance and encryption built-in
- **📊 Data Gravity**: Research documents and portfolio data in the same platform


---

*This lab demonstrates real-world enterprise AI implementation using Snowflake's comprehensive AI platform. All components are production-ready and represent actual customer use cases.*

