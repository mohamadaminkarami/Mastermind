#!/bin/bash

echo "🎮 Mastermind Game Demo"
echo "====================="
echo ""
echo "This demo will show you how to play the Mastermind game."
echo ""
echo "Building the game..."
swift build

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Build successful!"
    echo ""
    echo "Starting the game..."
    echo "Remember:"
    echo "- Enter 4-digit codes using digits 1-6"
    echo "- Type 'help' for instructions"
    echo "- Type 'example' to see examples"
    echo "- Type 'exit' to quit"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    
    swift run
else
    echo "❌ Build failed. Please check the error messages above."
    exit 1
fi 