'use client';

import { createContext, useContext, useState, useEffect } from 'react';
import Cookies from 'js-cookie';
import { ApiService } from '@/services/api';
import toast from 'react-hot-toast';
import { User, AuthTokens } from '@/types/auth';

interface AuthContextType {
  user: User | null;
  tokens: AuthTokens | null;
  setAuth: (user: User | null, tokens: AuthTokens | null) => void;
  clearAuth: () => void;
  isAuthenticated: boolean;
  updateUserProfile: (data: Partial<User>) => Promise<void>;
  refreshProfile: () => Promise<void>;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<User | null>(null);
  const [tokens, setTokens] = useState<AuthTokens | null>(null);

  const fetchUserProfile = async () => {
    try {
      const response = await ApiService.getUserProfile();
      if (response.data) {
        const updatedUser = { ...user, ...response.data };
        setUser(updatedUser);
        Cookies.set('user', JSON.stringify(updatedUser), {
          secure: true,
          sameSite: 'strict',
          expires: 1
        });
      }
    } catch (error) {
      console.error('Error fetching user profile:', error);
    }
  };

  useEffect(() => {
    // Check cookies for existing auth data
    const storedTokens = Cookies.get('auth_tokens');
    const storedUser = Cookies.get('user');
    
    if (storedTokens && storedUser) {
      try {
        setTokens(JSON.parse(storedTokens));
        setUser(JSON.parse(storedUser));
        // Fetch fresh profile data when auth is restored
        fetchUserProfile();
      } catch (e) {
        console.error('Error parsing stored auth data:', e);
        Cookies.remove('auth_tokens');
        Cookies.remove('user');
      }
    }
  }, []);

  const setAuth = async (newUser: User | null, newTokens: AuthTokens | null) => {
    setUser(newUser);
    setTokens(newTokens);
    
    if (newUser && newTokens) {
      // Store in cookies with secure flags
      Cookies.set('auth_tokens', JSON.stringify(newTokens), {
        secure: true,
        sameSite: 'strict',
        expires: 1
      });
      Cookies.set('user', JSON.stringify(newUser), {
        secure: true,
        sameSite: 'strict',
        expires: 1
      });
      // Fetch fresh profile data when auth is set
      await fetchUserProfile();
    } else {
      Cookies.remove('auth_tokens');
      Cookies.remove('user');
    }
  };

  const clearAuth = () => {
    setAuth(null, null);
  };

  const updateUserProfile = async (data: Partial<User>) => {
    if (!user) return;
    try {
      const response = await ApiService.updateUserProfile(data);
      // After updating, fetch fresh profile data
      await fetchUserProfile();
      toast.success('Profile updated successfully');
    } catch (error) {
      console.error('Error updating user profile:', error);
      toast.error('Failed to update profile');
      throw error;
    }
  };

  const isAuthenticated = !!user && !!tokens;

  return (
    <AuthContext.Provider
      value={{
        user,
        tokens,
        setAuth,
        clearAuth,
        isAuthenticated,
        updateUserProfile,
        refreshProfile: fetchUserProfile // Add this to allow manual refresh
      }}
    >
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
}
