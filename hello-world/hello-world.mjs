/**
 * Copyright (c) HashiCorp, Inc.
 * SPDX-License-Identifier: MPL-2.0
 */

// Lambda function code

export const handler = async (event, context) => {
  console.log('Received event:', JSON.stringify(event, null, 2));

  let responseMessage = 'Hello, World! My first Lambda via Terraform :)';
  if (event.queryStringParameters && event.queryStringParameters['name']) {
    responseMessage = 'Hello, ' + event.queryStringParameters['name'] + ', you found this query parameter!';
  }

  return {
    statusCode: 200,
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      message: responseMessage,
    }),
  }
};