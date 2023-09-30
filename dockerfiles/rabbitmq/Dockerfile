# Use the official RabbitMQ image as the base
FROM rabbitmq:3.9.12

# Maintenance label
#LABEL maintainer="your-email@example.com"

# Customize RabbitMQ configuration if needed
# For example, you can copy custom configuration files into the container
# COPY rabbitmq.config /etc/rabbitmq/rabbitmq.config

# Expose RabbitMQ ports (default 5672 for AMQP and 15672 for the management panel)
EXPOSE 5672 15672

# Command to start RabbitMQ
CMD ["rabbitmq-server"]
